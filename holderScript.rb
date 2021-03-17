require 'csv'

#this class parses the common holders of a token out of a csv file and prints them
class CommonHolders
    #Initializes class CommonHolders with an array of filenames
    def initialize(filenames, threshold)
        @filenames = filenames
        @threshold = threshold
        @h
        parse()
    end

    #parses the data from the csv files using the csv library
    def parse()
        files = []
        @filenames.each do |filename|
            files.push(CSV.parse(File.read(filename), headers: true))
        end
        turnHash(files)
    end

    #merges the tables into a hash (address => [balances])
    def turnHash(files)
        @h = Hash.new{|hash, key| hash[key] = Array.new()}
        files.each.with_index do |file, idx|
            file.each do |row|
                #makes balances only get added if its a common holder
                #this is more memory efficient
                @h[row[0]] << row[1] if @h[row[0]].length() == idx && ("%f" % row[1]).to_f > @threshold
                #if there are balances for all tickers then print
                p(row[0]) if @h[row[0]].length() == @filenames.length()
            end
        end
    end

    #prints the address and balance for individual addresses
    #"Address ticker: balance"
    def p(address)
        puts(address)
        @filenames.each.with_index do |filename, idx|
            puts(filename[0...-4] + ": " + @h[address][idx].to_s)
        end
        puts("\n")
    end
end

holders = CommonHolders.new(["fxs.csv", "ersdl.csv"], 1) #([tickers], float as dust coin threshold)