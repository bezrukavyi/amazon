module Support
  module UserAuth
    def sign_up(form_id, options)
      within "##{form_id}" do
        fill_in I18n.t('simple_form.labels.user.email'), with: options[:email]
        fill_passwords(options[:password])
        click_button I18n.t('simple_form.titles.sign_up')
      end
    end

    def sign_in(form_id, options)
      within "##{form_id}" do
        fill_in I18n.t('simple_form.labels.user.email'), with: options[:email]
        fill_in I18n.t('simple_form.labels.user.password'), with: options[:password]
        click_button I18n.t('simple_form.titles.log_in')
      end
    end

    def email_instruct(form_id, email)
      within "##{form_id}" do
        fill_in name: 'user[email]', with: email
        click_button I18n.t('devise.passwords.new.email_instruct')
      end
    end

    def reset_password(form_id, password)
      within "##{form_id}" do
        fill_passwords(password, 'new_password')
        click_button I18n.t('simple_form.titles.change')
      end
    end

    def fill_passwords(password, type = 'password')
      fill_in I18n.t("simple_form.labels.user.#{type}"), with: password
      fill_in I18n.t('simple_form.labels.user.password_confirmation'), with: password
    end
  end
end
