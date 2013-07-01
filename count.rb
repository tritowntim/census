require 'rubygems'
require 'bundler/setup'

Bundler.require

puts "PG gem #{PG.version_string}"

# add database addresses in psql style
orange = PG::Connection.new("dbname=")
green = PG::Connection.new("dbname=")

tables = <<-SQL
	    SELECT t.table_name
	      FROM information_schema.tables t
	     WHERE t.table_schema = 'public' AND table_type = 'BASE TABLE'
	  ORDER BY t.table_name
SQL

counts = []

orange.exec(tables).each do |table|
	puts table['table_name']
	sql = "SELECT COUNT(1) FROM #{table['table_name']}"
	count = {}
	count['table'] = table['table_name']

	unless count['table'] == ''

		begin
			orange.exec(sql) do |row|
				count['orange'] = row[0]['count']
			end
		rescue
			count['orange'] = 'N/A'
		end

		begin	
			green.exec(sql) do |row|
				count['green'] = row[0]['count']
			end
		rescue
			count['green'] = 'N/A'
		end

	end

	counts << count

end

counts.each do |c|
	puts "#{c['table']},#{c['orange']},#{c['green']},"
end


