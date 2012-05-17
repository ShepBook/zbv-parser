require 'date'

f = IO.readlines(ARGV[0])

def parse_line(line)
	if line =~ /\A\S/
		return "host"
	elsif line =~ /\A\s+\d{4}/
		return "date"
	elsif line =~ /\A\W{3}/
		return "discard"
	elsif line =~ /\n/
		return "empty"
	end
end

def parse_block(filearray)
  if parse_line(filearray[0]) == "discard"
    filearray.shift
  elsif parse_line(filearray[0]) == "empty"
    filearray.shift
  elsif parse_line(filearray[0]) == "host"
    host = filearray.shift
    while parse_line(filearray[0]) == "date"
      date = filearray.shift
    end
  end
  das_block = [host, date]
  return das_block
end

def find_vio(blockarray)
	vio_block = blockarray
	vio_regex = /\A\s+(\d{4})\W(\d{2})\W(\d{2})/

	today = Date.new(DateTime.now.year(), DateTime.now.month(), DateTime.now.day())
	m = vio_regex.match vio_block[-1]
	vio_date = Date.new(m[1].to_i, m[2].to_i, m[3].to_i)

	# checks if violation date is >= 15 days in past.
	if vio_date == nil
    return 0
  elsif vio_date < (today - 14)
		puts vio_block
	elsif vio_date > (today - 14)
		return 0
	end
end

def parse_file(file)
	while file.last != nil
		find_vio(parse_block(file))
	end
end

parse_file(f)