require 'csv'

class CommonHolders
    #Initializes class CommonHolders with an array of filenames
    def initialize(filenames)
        @filenames = filenames
        @commonHolders = []
        parse()
    end

    #parses the data from the csv files
    def parse()
        files = []
        @filenames.each do |filename|
            files.push(CSV.parse(File.read(filename), headers: true))
        end
        getCommons(files)
    end

    #gets common holders
    def getCommons(files)
        @commonHolders = files[0].by_col[0]
        files[1..-1].each do |file|
            @commonHolders = @commonHolders & file.by_col[0]
        end
    end

    #prints out common holders
    def print()
        @commonHolders.each do |holder|
            puts(holder)
        end
    end
end

holders = CommonHolders.new(["fxs.csv", "ersdl.csv"])
holders.print()