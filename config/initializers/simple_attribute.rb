SimpleAttribute.setup do |config|
  config.avatar   = { html: { class: 'rounded bordered' } }
  config.image    = { html: { class: 'thumbnail' }, default_value: 'upload-preview.svg' }
  config.boolean  = { true: 'success', false: 'alert', wrapper: { class: 'label' } }
  config.wrappers = { badge: { class: 'badge' } }

  config.wrappers do |wrapper|
    wrapper.label_default   = { class: 'label default' }
    wrapper.label_primary   = { class: 'label primary' }
    wrapper.label_secondary = { class: 'label secondary' }
    wrapper.label_info      = { class: 'label info' }
    wrapper.label_success   = { class: 'label success' }
    wrapper.label_warning   = { class: 'label warning' }
    wrapper.label_alert     = { class: 'label alert' }

    wrapper.badge_default   = { class: 'badge default' }
    wrapper.badge_primary   = { class: 'badge primary' }
    wrapper.badge_secondary = { class: 'badge secondary' }
    wrapper.badge_info      = { class: 'badge info' }
    wrapper.badge_success   = { class: 'badge success' }
    wrapper.badge_warning   = { class: 'badge warning' }
    wrapper.badge_alert     = { class: 'badge alert' }
  end
end
