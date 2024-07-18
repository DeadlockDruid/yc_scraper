class ExportManagerService
  # Expects a filename and a block that will handle how each row should be formatted
  def self.export_to_csv(data, file_name, headers, &format_block)
    file_path = "#{file_name}.csv"

    CSV.open(file_path, 'wb') do |csv|
      csv << headers

      data.each do |item|
        csv << format_block.call(item)
      end
    end

    puts "CSV generation complete. File saved to #{file_path}"
  end
end
