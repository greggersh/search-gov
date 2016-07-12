class Template::SquareHeaderLink < Template
  HUMAN_READABLE_NAME = "Square Header Links"
  TEMPLATE_DESCRIPTION = "In this template, the Header Menu appears as square boxes above the search bar and facets appear below the search bar."

  DEFAULT_SCHEMA = {
    "css" => {
      "font" => {
        "default_font" => "Tahoma",
        "font_family" => "Tahoma, Verdana, Arial, sans-serif"
      },
      "colors" => {
        "template" => {
          "page_background" => "#DFDFDF"
        },
        "header" => {
          "header_background_color" => "#FFFFFF",
          "header_text_color" => "#000000"
        },
        "facets" => {
          "active_facet_link_color" => "#9E3030",
          "facet_link_color" => "#505050"
        },
        "footer" => {
          "footer_background_color" => "#DFDFDF",
          "footer_links_text_color" => "#000000"
        },
        "header_links" => {
          "header_links_background_color" => "#F1F1F1",
          "header_links_text_color" => "#000000"
        },
        "results_container" => {
          "title_link_color" => "#2200CC",
          "visited_title_link_color" => "#800080",
          "result_url_color" => "#006800",
          "description_text_color" => "#000000"
        },
        "search_bar" => {
          "search_button_background_color" => "#00396F"
        },
        "tagline" => {
          "header_tagline_color" => "#FFFFFF",
          "header_tagline_background_color" => "#000000"
        }
      }
    }
  }
end