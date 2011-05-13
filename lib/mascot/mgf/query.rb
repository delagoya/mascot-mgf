module Mascot
  class MGF
    class Query

      attr_accessor :ions, :title, :pepmass, :entry, :charge

      # Initializes a spectrum entry from a MGF formatted string or from an Array
      # that is the newline split of MGF 'BEGIN IONS\n...\nEND IONS'
      def initialize(entry=nil)
        if entry.kind_of? String
          entry = entry.split(/\n/)
        end
        @title = 'id=1'
        @pepmass = []
        @atts = {}
        @ions = []
        @charge = nil
        parse(entry)
      end

      # Returns the formatted MGF entry string
      def to_s
        tmp = "BEGIN IONS\nTITLE=#{@title}\n"
        tmp += "PEPMASS=#{@pepmass.join(' ')}\n" if @pepmass.length > 0
        tmp += "CHARGE=#{@charge}+\n" if @charge
        @atts.each_pair do |k,v|
          tmp += "#{k.to_s.upcase}=#{v}\n"
        end
        tmp += @ions.collect { |i| i.join(" ")}.join("\n")
        tmp += "\nEND IONS\n"
        return tmp
      end

      def method_missing(m)
        if @atts.has_key? m.to_sym
          return @atts[m.to_sym]
        else
          return nil
        end
      end

      private

      def parse(entry)
        return nil if entry.nil?
        entry.each do |ln|
          if ln =~ /(\w+)=(.+)/
            case $1
            when "PEPMASS"
              @pepmass = $2.split(/\s/).collect {|e| e.to_f }
            when "TITLE"
              @title = $2
            when "CHARGE"
              @charge = $2.to_i
            else
              @atts[$1.downcase.to_sym] = $2
            end
          elsif ln =~ /^\d+/
            tmp = ln.split(/\s+/).map {|e| e.to_f }
            @ions << tmp
          else
            next
          end
        end
      end
    end
  end
end