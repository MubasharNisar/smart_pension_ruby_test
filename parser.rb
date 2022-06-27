# frozen_string_literal: true

require 'pry'
require_relative 'lib/page_views'
parser = PageViews.new(ARGV[0])
parser.process
parser.print parser.most_visits, 'Most Visits'
parser.print parser.unique_visits, 'Unique Visits'
