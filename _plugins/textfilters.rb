# frozen_string_literal: true

# Jekyll filters
module Jekyll
  # Filtering input text
  module TextFilter
    # Code for Liquid to find the first of a given weekday in a month/year.
    # 0-6 for the day of the week
    def first_w_of_month(date, dow)
      date.year
      next_month = date.month + 1
      day1 = Date.new date.year, next_month, 1
      wday = day1.wday

      wday == dow + 1 ? day1 - 1 : day1 + (9 - wday)
    end
  end
end

Liquid::Template.register_filter(Jekyll::TextFilter)
