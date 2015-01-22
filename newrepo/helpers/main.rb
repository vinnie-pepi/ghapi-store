@assignment = assignment

def date_tag
  "Date: #{Time.now.strftime("%Y-%m-%d")}"
end

def generate_text_input(name, options={}, &block)
  html = ''
  html += content_tag(:label, options[:label]) if options[:label]
  html += content_tag(:input, '', { type: 'text', class: 'form-control', name: name, value: get_val_at(name), placeholder: options[:placeholder] || nil })
  html += capture(&block) if block_given?

  content_tag(:div, class: 'form-group') do
    html.html_safe
  end
end

def generate_radio(value, name, options={})
  label = options[:label] || value
  content_tag(:div, class: 'radio') do
    content_tag(:label) do
      content_tag(:input, '', { value: value, name: name, type: 'radio', checked: checked?(name, value) }).concat(label)
    end
  end
end

def generate_checkbox(value, name, options={})
  label = options[:label] || value
  content_tag(:div, class: 'checkbox') do
    content_tag(:label) do
      content_tag(:input, '', { value: value, name: name, type: 'checkbox', checked: checked?(name, value) }).concat(label)
    end
  end
end

def split_input_name(name)
  nested_attrs = name.split(/[\[\]]{1,2}/)
  nested_attrs.shift #remove assignment
  return nested_attrs
end

def get_val_at(name)
  nested_attrs = split_input_name(name)
  ref = @assignment
  nested_attrs.each do |n|
    if ref[n] 
      ref = ref[n]
    else
      ref = ''
    end
  end
  return ref
end

def checked?(name, value)
  return get_val_at(name) == value
end
