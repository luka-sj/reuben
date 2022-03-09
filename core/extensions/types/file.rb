#===============================================================================
#  `File` class extensions
#===============================================================================
class ::File
  class << self
    #---------------------------------------------------------------------------
    #  Copies the source file to the destination path
    #---------------------------------------------------------------------------
    def copy(source, destination)
      data = ''
      File.open(source, 'rb') do |f|
        loop do
          buffer = f.read(4096)
          break unless buffer

          data << buffer
        end
      end
      File.delete(destination) if File.exist?(destination)
      File.open(destination, 'wb') do |f|
        f.write data
      end
    end
    #---------------------------------------------------------------------------
    #  Copies the source to the destination and deletes the source
    #---------------------------------------------------------------------------
    def move(source, destination)
      File.copy(source, destination)
      File.delete(source)
    end
    #---------------------------------------------------------------------------
    #  Extract contents of zip file
    #---------------------------------------------------------------------------
    def extract(file)
      log "Extracting contents from '#{file}' ..."
      open(file, 'r') do |f|
        #  open Zip buffer
        Zip::File.open_buffer(f.read) do |zip|
          zip.each do |entry|
            #  create necessary directories
            new_dir = File.dirname(entry.name)
            Dir.create(new_dir) unless new_dir == '.'

            #  extract directory
            entry.extract
          end
        end
      end
      #  delete file after extraction
      delete(file)
    end
    #---------------------------------------------------------------------------
    #  Compress files into a zip file
    #---------------------------------------------------------------------------
    def compress(file, dir, files)
      File.delete(file) if File.exist?(file)
      log "Compressing contents into '#{file}' ..."
      Zip::File.open(file, create: true) do |zipfile|
        #  iterate through files to zip
        files.each do |filename|
          zipfile.add(filename, File.join(dir, filename))
        end
      end
    end
    #---------------------------------------------------------------------------
  end
end
