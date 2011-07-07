include ActionDispatch::TestProcess

# Upload a file within a test using the
# ActionDispatch::TestProcess.fixture_file_upload method.
#
# @param [ String ] filename The name of the file to upload on disk.
# @param [ String ] content_type The content type to use when uploading fhe
#   file.
def upload_file(filename, content_type)
  fixture_file_upload(File.join(Rails.root, 'spec', 'files', filename), content_type)
end
