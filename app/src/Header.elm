module Header exposing (..)

import Html exposing (Html, a, button, div, text, p)
import Html.Attributes exposing (class, href)

-- MODEL

type alias NavItem =
  { name : String
  , link : String
  }

type alias Model =
  { itemsNav : List NavItem
  }

init : Model
init =
  { itemsNav = 
    [ { name = "Accueil"
      , link = "/"
      }
    , { name = "A propos"
      , link = "/about"
      }
    , { name = "Catégories"
      , link = "/categories"
      }
    ]
  }

-- UPDATE

type Msg
  = SetItemsNav (List NavItem)

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetItemsNav items ->
      { model | itemsNav = items }

-- VIEW

renderItem : NavItem -> Html msg
renderItem item = 
  a [ href item.link ] [ text item.name ]

view : Model -> Html msg
view model =
  let 
    navbar =
      List.map renderItem model.itemsNav
    in
      div [ ] navbar