# Ractor-Based Parallel Processor (Ruby 3.0+)

class RactorProcessor
  def self.process(items, &block)
    ractors = items.map do |item|
      Ractor.new(item, &block)
    end

    ractors.map(&:take)
  end
end

# Ractor Worker Pool for more controlled parallel processing
class RactorWorkerPool
  def initialize(worker_count: 4)
    @worker_count = worker_count
    @workers = nil
  end

  def start
    @workers = Array.new(@worker_count) do
      Ractor.new do
        loop do
          msg = Ractor.receive
          break if msg == :shutdown

          begin
            result = yield(msg[:data])
            Ractor.yield({ id: msg[:id], result: result, error: nil })
          rescue => e
            Ractor.yield({ id: msg[:id], result: nil, error: e.message })
          end
        end
      end
    end
    self
  end

  def process(items, &block)
    # Simple approach: one Ractor per item
    ractors = items.each_with_index.map do |item, index|
      Ractor.new(item, index, block) do |data, id, worker|
        result = worker.call(data)
        { id: id, result: result }
      end
    end

    results = ractors.map(&:take)
    results.sort_by { |r| r[:id] }.map { |r| r[:result] }
  end

  def shutdown
    @workers&.each { |w| w.send(:shutdown) rescue nil }
    self
  end
end
