# encoding: utf-8
#

# Handles service hook requests from Github and persists the information as SCM
# comments for the relevant tickets.
class GithubServiceHook

  attr_reader :instance, :data

  # Initialize the service hook with the JSON data passed in from Github.
  #
  # @param [ Instance ] instance The instance where the hook should operate.
  # @param [ String ] json The raw JSON passed in from Github.
  def initialize(instance, json)
    @instance = instance
    @data = JSON.parse(json, symbolize_names: true)
  end

  # Return a list of comment definitions based on the identifiable commit
  # messages in the JSON data.
  #
  # @return [ Array ] An array of CommentDefinition instances holding
  #   descriptions of all the identified comments in the commit messages.
  def comments
    @comments ||= find_comments
  end

  # Parse the service hook data and persist scm comments for all the
  # recognizable commits.
  def handle!
    persist_comments
    close_tickets
  end

  private

  # Persist the comments identified from the JSON data.
  def persist_comments
    comments.each do |comment_definition|
      comment_definition.tickets.each do |ticket|

        # Build the comment for this ticket.
        comment = ScmComment.new
        comment.instance = ticket.project.instance
        comment.commentable = ticket
        comment.user = comment_definition.user
        comment.scm = ScmComment::SCMS.key(:github).to_i
        comment.repository = @data[:repository][:url]
        comment.reference = comment_definition.sha
        comment.body = comment_definition.message

        # Add the files
        comment_definition.added_files.each do |file|
          comment.files.build(action: ScmCommentFile::ACTIONS.key(:add).to_i, path: file)
        end
        comment_definition.removed_files.each do |file|
          comment.files.build(action: ScmCommentFile::ACTIONS.key(:remove).to_i, path: file)
        end
        comment_definition.modified_files.each do |file|
          comment.files.build(action: ScmCommentFile::ACTIONS.key(:change).to_i, path: file)
        end

        comment.save!

      end
    end
  end

  # Close all requested tickets based on the commands in the JSON data.
  def close_tickets
    comments.each do |comment_definition|

      if comment_definition.close_command
        comment_definition.tickets.each do |ticket|
          ticket.close!
        end
      end

    end
  end

  # Build a list of comment definitions based on all identifiable commit
  # messages in the JSON data.
  #
  # @return [ Array ] An array of CommentDefinition instances holding
  #   descriptions of all the identified comments in the commit messages.
  def find_comments

    # Build a regular expression that matches all known ticket ID formats. This
    # regular expression is case insensitive.
    ticket_identifier = Regexp.new("(#{project_key_map.keys.collect { |key| Regexp.quote(key) }.join('|')})\\-(\\d+)", true)

    comments = []
    @data[:commits].each do |commit|

      sha = commit[:id]
      email = commit[:author][:email]
      message = commit[:message]
      added_files = commit[:added] || []
      removed_files = commit[:removed] || []
      modified_files = commit[:modified] || []

      # Some defaults.
      close_command = false
      logged_time = nil

      #
      # Attempt to map the e-mail address from the commit to a Unify user.
      #
      user = User.for_instance(@instance).with_email_address(email).first
      unless user.blank?

        # We found a user. Tokenize the commit message and try to identify one
        # or more ticket identifiers at the beginning of the message.
        tokenized_message = message.split(/\s+/)
        tickets = []

        tokenized_message.dup.each do |message_token|

          if message_token =~ ticket_identifier
            
            project = project_key_map[$1.downcase]
            ticket_sequence = $2.to_i

            # Remove one element from the tokenized message so we'll end up with a
            # message that's stripped for commands.
            tokenized_message.shift
            
            # Attempt to load the ticket
            ticket = project.tickets.where(sequence: ticket_sequence).first
            tickets << ticket unless ticket.blank?

          else
            break
          end
        end

        # If we have identified one or more tickets, check for other commands we
        # need to apply.
        if tickets.size > 0 && tokenized_message.size > 0
          while tokenized_message.size > 0

            if tokenized_message.first =~ /^(#close|@([0-9hm]){1,})$/

              command = tokenized_message.shift
              if command == '#close'
                close_command = true
              else
                logged_time = command[1..-1] # Strip off the @ symbol.
              end

            else
              break
            end

          end
        end

        # If there is still anything left in the tokenized message, and we have
        # one or more tickets, construct a comment definition and add it to the
        # list.
        if tickets.size > 0 && !tokenized_message.empty?
          comments << CommentDefinition.new(user, sha, tickets, tokenized_message.join(' '), close_command, logged_time, added_files, removed_files, modified_files)
        end

      end
      
    end

    comments
    
  end
  
  # Returns a hash of project keys, with the project as the value, for the
  # current instance.
  #
  # @return [ Hash ] A hash of projects, where the key attribute on the project
  #   is the key of the hash, and the project instance itself the value.
  def project_key_map

    unless defined?(@project_key_map)
      projects = Project.for_instance(@instance)
      project_keys = projects.collect(&:key)
      @project_key_map = projects.inject({}) do |hash, project|
        hash[project.key.downcase] = project
        hash
      end
    end
    @project_key_map
    
  end

  # This class holds the definition of a comment before its processed and
  # persisted to the database.
  class CommentDefinition

    attr_reader :user, :sha, :tickets, :message, :close_command, :logged_time, :added_files, :removed_files, :modified_files

    def initialize(user, sha, tickets, message, close_command, logged_time, added_files, removed_files, modified_files)
      @user = user
      @sha = sha
      @tickets = tickets
      @message = message
      @close_command = close_command
      @logged_time = logged_time
      @added_files = added_files
      @removed_files = removed_files
      @modified_files = modified_files
    end

  end

end
