# Exercise 2: Open/Closed Principle Implementation

Build extensible systems that don't require modification when adding new features.

## Challenge: Extensible Report Generator

Build a report generator that supports PDF, Excel, and CSV without modifying existing code.

```ruby
# TODO: Implement extensible report generator
# Requirements:
# 1. Base ReportGenerator class/interface
# 2. PDF, Excel, CSV implementations
# 3. Easy to add new formats
# 4. No modification to existing code when adding formats
```

<details>
<summary>Solution</summary>

```ruby
# app/services/reports/base_generator.rb
module Reports
  class BaseGenerator
    def initialize(data)
      @data = data
    end

    def generate
      raise NotImplementedError
    end

    protected

    attr_reader :data
  end
end

# app/services/reports/pdf_generator.rb
module Reports
  class PdfGenerator < BaseGenerator
    def generate
      Prawn::Document.new do |pdf|
        pdf.text "Report"
        data.each do |row|
          pdf.text row.to_s
        end
      end.render
    end
  end
end

# app/services/reports/csv_generator.rb
module Reports
  class CsvGenerator < BaseGenerator
    def generate
      CSV.generate do |csv|
        csv << data.first.keys
        data.each do |row|
          csv << row.values
        end
      end
    end
  end
end

# app/services/reports/excel_generator.rb
module Reports
  class ExcelGenerator < BaseGenerator
    def generate
      package = Axlsx::Package.new
      package.workbook.add_worksheet do |sheet|
        sheet.add_row data.first.keys
        data.each do |row|
          sheet.add_row row.values
        end
      end
      package.to_stream.read
    end
  end
end

# Usage - extensible without modification
class ReportController < ApplicationController
  GENERATORS = {
    'pdf' => Reports::PdfGenerator,
    'csv' => Reports::CsvGenerator,
    'excel' => Reports::ExcelGenerator
  }.freeze

  def show
    generator = GENERATORS[params[:format]].new(report_data)
    send_data generator.generate, filename: "report.#{params[:format]}"
  end
end
```
</details>

## Key Learning

New report formats can be added without modifying existing code—just create a new generator class.
