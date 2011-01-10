module Mascot
  class MGF < File
    require 'mascot/mgf/query'
    attr_reader :idx, :full_path
    def initialize(mgf_file_path,open_mode="r",cache_index=true)
      super(mgf_file_path, open_mode)
      @full_path = File.expand_path(mgf_file_path)
      @cache_index = cache_index
      @curr_index = 0
      @idx = {}
      parse_index()
    end

    def readquery(n=nil)
      if n
        @curr_index = n
      end
      self.pos = @idx[@curr_index][0]
      bytelength = @idx[@curr_index][1] - @idx[@curr_index][0]
      @curr_index += 1
      self.read(bytelength)
    end
    
    def each_query
      while !self.eof?
        yield self.query() if block_given?
      end
    end

    def query(n=nil)
      Mascot::MGF::Query.new(self.readquery(n))
    end
    
    # reports how many queries are in this MGF file
    def query_count()
      return @idx.length
    end

    private

    def parse_index()
      if File.exists?(@full_path + ".idx")
        # read the index from file
        idx_file = File.open(@full_path + ".idx",'rb')
        @idx = ::Marshal.load(idx_file)
        idx_file.close
      else
        create_index()
      end
    end

    def create_index()
      @idx = []
      # state tracker, 0 => not in a ions boundary, 1 => in a query
      ion_boundary_state = 0
      self.rewind
      self.grep(/^(\w+) IONS$/) do |l|
        case $1
        when "BEGIN"
          @idx << [self.pos - l.length, nil]
        when "END"
          @idx[-1][1] = self.pos
        end
      end   
      if @cache_index
        idx_file = File.open(@full_path + ".idx",'wb')
        idx_file.print(::Marshal.dump(@idx))
        idx_file.close
      end
      # place cursor at beginning of file again
      self.rewind
    end
  end
end