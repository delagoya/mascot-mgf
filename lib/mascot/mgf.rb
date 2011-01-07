require 'mascot/mgf/query'
module Mascot
  class MGF < File
    VERSION = "0.2.0"
    
    attr_reader :idx
    
    def initialize(mgf_file_path,open_mode="r",cache_index=true)
      super(mgf_file_path,open_mode)
      @full_path = File.expand(mgf_file_path)
      @cache_index = cache_index
      @curr_index = 0
      @idx = {}
      parse_index()
    end
    def readquery
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
      if n
        self.pos = @idx[n][0]
      end
      parse_next_query(@idx[n][1])
    end

    private
    
    def parse_next_query(bytelength)
      return nil if self.eof?
      # move the idx cursor forward
      @curr_index += 1
      Mascot::MGF::Query.new(self.read(bytelength))
    end

    def parse_index()
      if File.exists?(@full_path + ".idx")
        # read the index from file
        idx_file = File.open(@full_path + ".idx",'rb')
        @idx = Marshall.load(idx_file)
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
        idx_file.print(Marshal.dump(@idx))s
        idx_file.close
      end
      # place cursor at beginning of file again
      self.rewind
    end
  end
end