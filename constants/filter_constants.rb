LOWER_STEPS = [1, 5, 10, 25, 50, 100, 250, 500, 1000]
UPPER_STEPS = [1000, 500, 250, 100, 50, 25, 10, 5, 1]

FILTER_ACTIONS = {
  batch: {
    action: :toggle_checkbox_list,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')][h4[contains(text(), 'Batch')]]" },
    options: { 
      expand_link: 'See all options',
      scrollable: false
    }
  },
  industry: {
    action: :toggle_checkbox_list,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')][h4[contains(text(), 'Industry')]]" },
    options: { 
      expand_link: 'See all options',
      scrollable: false
    }
  },
  region: {
    action: :toggle_checkbox_list,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')][h4[contains(text(), 'Region')]]" },
    options: {}
  },
  tag: {
    action: :toggle_checkbox_list,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')][h4[contains(text(), 'Tags')]]/div[contains(@class, '_typeaheadResults_')]" },
    options: { 
      expand_link: nil,
      scrollable: true
    }
  },
  company_size: {
    action: :set_slider,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')]/h4[contains(text(), 'Company Size')]/following-sibling::div[contains(@class, 'noUi-horizontal')]" },
    options: {}
  },
  top_companies: {
    action: :toggle_checkbox,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')]//label[span[contains(text(), 'Top Companies')]]/input[@type='checkbox']" },
    options: {}
  },
  is_hiring: {
    action: :toggle_checkbox,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')]//label[span[contains(text(), 'Is Hiring')]]/input[@type='checkbox']" },
    options: {}
  },
  nonprofit: {
    action: :toggle_checkbox,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')]/label[span[contains(text(), 'Nonprofit')]]/input[@type='checkbox']" },
    options: {}
  },
  black_founded: {
    action: :toggle_checkbox,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')]/label[span[contains(text(), 'Black-founded')]]/input[@type='checkbox']" },
    options: {}
  },
  hispanic_latino_founded: {
    action: :toggle_checkbox,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')]/label[span[contains(text(), 'Hispanic & Latino-founded')]]/input[@type='checkbox']" },
    options: {}
  },
  women_founded: {
    action: :toggle_checkbox,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')]/label[span[contains(text(), 'Women-founded')]]/input[@type='checkbox']" },
    options: {}
  },
  public_application_video: {
    action: :toggle_checkbox,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')]/label[span[contains(text(), 'Public Application Video')]]/input[@type='checkbox']" },
    options: {}
  },
  public_demo_day_video: {
    action: :toggle_checkbox,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')]/label[span[contains(text(), 'Public Demo Day Video')]]/input[@type='checkbox']" },
    options: {}
  },
  has_application_answers: {
    action: :toggle_checkbox,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')]/label[span[contains(text(), 'Has Application Answers')]]/input[@type='checkbox']" },
    options: {}
  },
  has_bonus_questions: {
    action: :toggle_checkbox,
    selector: { type: :xpath, value: "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_facet_')]/label[span[contains(text(), 'Has Bonus Questions')]]/input[@type='checkbox']" },
    options: {}
  }
}.freeze
