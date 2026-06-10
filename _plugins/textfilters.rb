# frozen_string_literal: true

# Jekyll filters
module Jekyll
  # Filtering input text
  module TextFilter
    # Only relevant numbers; should become more algorithmic for the
    # general case.
    TERMS = {
      1 => 'first',
      2 => 'second',
      3 => 'third',
      4 => 'fourth',
      5 => 'fifth',
      6 => 'sixth',
      7 => 'seventh',
      28 => 'twenty-eighth',
      29 => 'twenty-ninth',
      30 => 'thirtieth',
      31 => 'thirty-first'
    }.freeze

    # Code for Liquid to find the first of a given weekday in a month/year.
    # 0-6 for the day of the week
    def first_w_of_month(date, dow)
      day1 = Date.new date.year, date.month + 1, 1
      wday = day1.wday

      wday == (dow + 1) % 7 ? day1 - 1 : (day1 + dow + 7 - wday) % 7
    end

    # Convert 2 to "second," etc.
    def ordinal_word(input)
      TERMS[input.to_i]
    end
  end
end

Liquid::Template.register_filter(Jekyll::TextFilter)
