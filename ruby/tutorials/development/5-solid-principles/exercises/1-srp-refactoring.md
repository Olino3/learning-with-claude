# Exercise 1: Single Responsibility Principle Refactoring

Refactor classes to follow SRP by extracting responsibilities into focused classes.

## Challenge: Refactor God Object

```ruby
class Report < ApplicationRecord
  def generate_pdf
    pdf = Prawn::Document.new
    pdf.text title
    pdf.text body
    pdf.render_file("reports/#{id}.pdf")
  end

  def send_email
    ReportMailer.send_report(self).deliver_now
  end

  def validate_data
    errors.add(:base, "Invalid data") unless data.valid_json?
  end

  def calculate_statistics
    {
      total: data.count,
      average: data.sum / data.count
    }
  end
end
```

**Task**: Extract into separate classes following SRP.

<details>
<summary>Solution</summary>

```ruby
# app/models/report.rb - Domain model only
class Report < ApplicationRecord
  validates :title, :data, presence: true
end

# app/services/reports/pdf_generator.rb
module Reports
  class PdfGenerator
    def initialize(report)
      @report = report
    end

    def generate
      pdf = Prawn::Document.new
      pdf.text @report.title
      pdf.text @report.body
      pdf.render_file(file_path)
    end

    private

    def file_path
      "reports/#{@report.id}.pdf"
    end
  end
end

# app/services/reports/email_sender.rb
module Reports
  class EmailSender
    def initialize(report)
      @report = report
    end

    def send
      ReportMailer.send_report(@report).deliver_now
    end
  end
end

# app/services/reports/statistics_calculator.rb
module Reports
  class StatisticsCalculator
    def initialize(report)
      @report = report
    end

    def calculate
      {
        total: data.count,
        average: data.sum / data.count
      }
    end

    private

    def data
      @report.data
    end
  end
end
```
</details>

## Key Learning

Each class now has a single, well-defined responsibility making them easier to test, maintain, and reuse.
