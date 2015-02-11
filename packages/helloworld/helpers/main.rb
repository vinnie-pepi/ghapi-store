@fields = [
  'name',
  'address',
  'locality',
  'region',
  'country',
  'website',
  'tel',
  'latitude',
  'longitude'
]

def google_search_link(name, address, locality)
  search_fields = [ name, address, locality ]
  search_query = CGI.escape(search_fields.join(' '))
  link_to 'Google Search This Place', "https://www.google.com/search?q=#{search_query}", target: '_blank'
end

def normalize_category_labels(category_labels)
  if category_labels.is_a?(Hash)
    category_labels.sort_by do |idx, val|
      idx
    end.collect do |x|
      normalize_category_labels(x[1])
    end
  else
    category_labels
  end
end

def get_ride_of_social(category_labels)
  category_labels.map do |cl|
    if cl[0].downcase == 'social'
      cl.shift
    end
    cl
  end
end

def questions(inputs)
  tmp = {}

  category_labels = normalize_category_labels(inputs['category_labels'])
  category_labels = get_ride_of_social(category_labels)

  category_labels.each_with_index do |cl, i|
    question = tmp[cl[0]] ||= {
      id: "top_level_category_appropriate_#{i}",
      text: "Appropriate Category? #{cl[0]}",
      children: []
    }

    if cl.size > 1 # meaning have second level category
      idx = question[:children].size
      question[:children] << {
        # id: "secondary_level_category_appropriate_#{i}_#{idx}",
        id: "secondary_level_category_appropriate_#{idx}",
        text: "Appropriate Category? #{cl.last}"
      }
    end
  end

  tmp.map { |k, v| v }
end
