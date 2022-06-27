# frozen_string_literal: true

class PageViews # rubocop:disable Style/Documentation
  attr_accessor :file_path, :data_hash

  def initialize(file_path)
    @file_path = file_path
    @data_hash = Hash.new { |hash, key| hash[key] = [] }
  end

  def process
    raise "No such file or directory '#{@file_path}'" unless file_path_valid?

    IO.readlines(@file_path).each do |line|
      page, ip = line.split
      @data_hash[page] << ip
    end
  end

  def most_visits
    compute_visits_count(false).sort_by { |_k, v| -v }.to_h
  end

  def unique_visits
    compute_visits_count(true).sort_by { |_k, v| -v }.to_h
  end

  def print(data, str)
    p str
    data.each { |key, value| p "#{key} : #{value}" }
    p '.................'
  end

  private

  def compute_visits_count(is_unique)
    @data_hash.transform_values { |v| is_unique ? v.uniq.size : v.size }
  end

  def file_path_valid?
    File.exist? @file_path
  end
end
