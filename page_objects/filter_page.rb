require_relative '../constants/filter_constants.rb'


class FilterPage
  def initialize(filters, browser)
    @browser = browser
    @number_of_companies = filters['number_of_companies']
    @filters = filters['filters']
    @skipped_filters = []
  end

  def apply_filters
    @browser.goto ::URL

    @browser.wait_until { 
      @browser.div(class: /_facets_/).exists? &&
      @browser.div(class: /_facets_/).visible?
    }

    @filters.each do |filter_key, filter_value|
      filter_action = FILTER_ACTIONS[filter_key.to_sym]
      selector = filter_action[:selector][:value]
      options = filter_action[:options]

      action_method = method_for_action(filter_action[:action])
      action_method.call(selector, filter_key, filter_value, options)
    end

    # Allow companies to load
    sleep 1
    @skipped_filters
  end

  private

  def method_for_action(action)
    case action
    when :toggle_checkbox_list, :toggle_checkbox, :set_slider
      method(action)
    else
      raise ActionMethodError, "Action #{action} is not implemented"
    end
  end

  def toggle_checkbox(selector, filter_key, filter_values, options = {})
    checkbox = @browser.checkbox(xpath: selector)

    if checkbox.exists?
      update_checkbox(checkbox, filter_values)
    else
      @skipped_filters << { filter: filter_key, reason: 'Checkbox for the filter not found' }
    end
  end

  def toggle_checkbox_list(selector, filter_key, filter_values, options = {})
    checkboxes_container = @browser.div(xpath: selector)

    if checkboxes_container.exists?
      if options[:expand_link]
        expand_link = checkboxes_container.link(text: options[:expand_link])
        expand_link.click if expand_link.exists?
      end

      checkboxes_container.checkboxes(type: 'checkbox').each do |checkbox|
        label = checkbox.parent.span(class: /_label_/)
        
        if label.exists? && label.visible?
          label_text = label.text.strip
          label_text = label_text.sub(/\d+$/, '').strip if options[:scrollable]

          should_check = filter_values.include?(label_text)
          update_checkbox(checkbox, should_check)
        else
          @skipped_filters << { filter: filter_key, reason: 'Checkbox label for the filter not found' }
        end
      end
    else
      @skipped_filters << { filter: filter_key, reason: 'Checkboxes for the filter not found' }
    end
  end

  def update_checkbox(checkbox, should_be_checked)
    if should_be_checked
      checkbox.set unless checkbox.set?
    else
      checkbox.clear if checkbox.set?
    end
  end

  def set_slider(selector, filter_key, filter_values, options = {})
    lower_bound, upper_bound = filter_values.split('-').map(&:to_i)

    @browser.wait_until { @browser.div(class: 'noUi-target').exists? }

    lower_slider = @browser.div(class: 'noUi-handle-lower')
    upper_slider = @browser.div(class: 'noUi-handle-upper')

    unless lower_slider.exists? && upper_slider.exists?
      @skipped_filters << { filter: filter_key, reason: 'Slider handles not found' }
    end

    adjust_slider_handle(lower_slider, lower_bound, true)
    adjust_slider_handle(upper_slider, upper_bound, false)
  end

  def nearest_step(value, is_lower_handle)
    steps = is_lower_handle ? LOWER_STEPS : UPPER_STEPS
    steps.min_by { |step| (value - step).abs }
  end

  def adjust_slider_handle(slider_handle, target_value, is_lower_handle)
    current_value = slider_handle.attribute_value("aria-valuetext").gsub(/[+,]/, '').to_i
    nearest_value = nearest_step(target_value, is_lower_handle)

    while current_value != nearest_value
      direction_key = current_value < nearest_value ? :arrow_right : :arrow_left
      slider_handle.send_keys(direction_key)
      sleep 0.1
      current_value = slider_handle.attribute_value("aria-valuetext").gsub(/[+,]/, '').to_i
    end
  end
end
