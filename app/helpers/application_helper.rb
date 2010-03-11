# -*- coding: iso-8859-1 -*-
module ApplicationHelper
  def show_flash_messages
    unless (flash.nil? or flash.empty?)
      html = content_tag(:div, flash.collect{ |key, msg| content_tag(:div, msg, :class => key) }, :id => 'flash-message', :class => 'flash-message')
      html << content_tag(:script, "setTimeout(\"new Effect.Fade('flash-message');\",15000)", :type => 'text/javascript')
      html
    end
  end

  def url_for_mobile_mode(new_mobile_mode)
    new_params = request.params.update({:m => new_mobile_mode.to_s})
    url_for({:controller => params[:controller], :action => params[:action], :params => new_params})
  end

  def link_to_mobile_mode(text, new_mobile_mode)
    link_to(text, url_for_mobile_mode(new_mobile_mode))
  end

  HEADER_LINKS = {
    :en => [
      ["USA.gov", "http://usa.gov"],
      ["GobiernoUSA.gov", "http://GobiernoUSA.gov"],
      ["Email USA.gov", "http://www.usa.gov/questions"]
    ],
    :es => [
      ["GobiernoUSA.gov", "http://GobiernoUSA.gov"],
      ["USA.gov (en inglés)", "http://usa.gov"],
      ["Contáctenos", "http://www.usa.gov/gobiernousa/Contactenos.shtml"]
    ]
  }

  FOOTER_LINKS = {
    :en => [
      ["Home", "http://www.usa.gov/index.shtml" ],
      ["About Us", "http://www.usa.gov/About.shtml" ],
      ["Contact Us", "http://www.usa.gov/Contact_Us.shtml" ],
      ["Contact Government", "http://www.usa.gov/Contact/Elected.shtml" ],
      ["FAQs", "http://www.usa.gov/Contact/Faq.shtml" ],
      ["Website Policies", "http://www.usa.gov/About/Important_Notices.shtml" ],
      ["Privacy", "http://www.usa.gov/About/Privacy_Security.shtml" ],
      ["Suggest-A-Link", "http://www.usa.gov/feedback/SuggestLinkForm.jsp" ],
      ["Link to Us", "http://www.usa.gov/About/Usagov_Logos.shtml"],
      ["Accessibility", "/pages/accessibility"]
    ],
    :es => [
      ["GobiernoUSA.gov", "http://GobiernoUSA.gov"],
      ["Privacidad", "http://www.usa.gov/gobiernousa/Privacidad_Seguridad.shtml"],
      ["Enlace su sitio al nuestro", "http://www.usa.gov/gobiernousa/link_to_us.shtml"],
      ["Sugiera un enlace", "http://www.usa.gov/feedback/sugieraunenlaceformulario.jsp"]
    ]
  }

  BACKGROUND_COLORS = { :en => "#003366", :es => "#A40000" }

  def header_links
    iterate_links(HEADER_LINKS[I18n.locale.to_sym])
  end

  def footer_links
    iterate_links(FOOTER_LINKS[I18n.locale.to_sym].clone << ["Mobile", url_for_mobile_mode("true")])
  end

  def render_webtrends_code
    if params[:locale] == 'es'
      render :partial => 'shared/webtrends_spanish'
    else
      render :partial => 'shared/webtrends_english'
    end
  end

  def basic_header_navigation_for(cur_user)
    elements = []
    if cur_user
      elements << cur_user.email
      elements << link_to("My Account", account_path)
      elements << link_to("Logout", user_session_path, :method => :delete)
      elements << link_to("Users", admin_users_path) if cur_user.is_affiliate_admin?
    else
      elements << link_to("Login", new_user_session_path)
      elements << link_to("Register", new_account_path)
    end
    elements << mail_to(APP_EMAIL_ADDRESS, "Contact Us")
    elements << link_to("FAQ", "http://searchsupport.usa.gov/")
    elements << link_to("search.usa.gov", home_page_path)
    elements.join(" | ")
  end

  def analytics_header_navigation_for(cur_user)
    elements = []
    if cur_user
      elements << cur_user.email
      elements << link_to("My Account", account_path)
      elements << link_to("Logout", user_session_path, :method => :delete)
      elements << link_to("FAQ", analytics_faq_path)
      elements << link_to("Query Groups Admin", analytics_query_groups_path) if cur_user.is_affiliate_admin?
      elements << link_to("Usage Reports", monthly_reports_path) if cur_user.is_analyst?
    end
    elements << link_to("search.usa.gov", home_page_path)
    elements.join(" | ")
  end

  def other_locale_str
    I18n.locale.to_s == "en" ? "es" : "en"
  end

  def english_locale?
    I18n.locale.to_s == "en"
  end

  def locale_dependent_background_color
    BACKGROUND_COLORS[I18n.locale.to_sym] || BACKGROUND_COLORS[:en]
  end

  def highlight_hit(hit, sym)
    return hit.highlights(sym).first.format { |phrase| "<strong>#{h phrase}</strong>" } unless hit.highlights(sym).first.nil?
    hit.instance.send(sym)
  end

  private

  def iterate_links(links)
    links.collect {|link| link_to(link[0], link[1]) }.join(' | ') unless links.nil?
  end
end
