module Jekyll
  class LayoutReader
    attr_reader :site
    def initialize(site)
      @site = site
      @layouts = {}
    end

    def read
      layout_entries.each do |f|
        @layouts[layout_name(f)] = Layout.new(site, layout_directory, f)
      end

      @layouts
    end

    def layout_directory
      @layout_directory ||= (layout_directory_in_cwd || layout_directory_inside_source)
    end

    private

    def layout_entries
      entries = []
      within(layout_directory) do
        entries = EntryFilter.new(site).filter(Dir['**/*.*'])
      end
      entries
    end

    def layout_name(file)
      file.split(".")[0..-2].join(".")
    end

    def within(directory)
      return unless File.exists?(directory)
      Dir.chdir(directory) { yield }
    end

    def layout_directory_inside_source
      # TODO: Fix for Windows
      File.join(site.source, File.expand_path(site.config['layouts'], "/"))
    end

    def layout_directory_in_cwd
      # TODO: Fix on Windows
      dir = File.join(Dir.pwd, File.expand_path(site.config['layouts'], '/'))
      if File.directory?(dir)
        dir
      else
        nil
      end
    end
  end
end
