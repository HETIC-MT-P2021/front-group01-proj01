module Header exposing (..)

import Html exposing (Html, a, div, text, img, ul, li, h1)
import Html.Attributes exposing (class, href, src)

-- MODEL

type alias NavItem =
    { name: String
    , link: String
    }

type alias Model =
    { 
        itemsNav : List NavItem
    }

init : Model
init =
    { itemsNav = 
        [ { name = "Accueil"
        , link = "/"
        }
        , { name = "Les images"
        , link = "/images"
        }
        , { name = "Les Catégories"
        , link = "/categories"
        }
        , { name = "A propos"
        , link = "/about"
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
    li [class "nav-item"] [a [class "nav-link", href item.link ] [ text item.name ]]

renderItems : List NavItem -> Html msg
renderItems items = 
    let 
        navbar = List.map renderItem items
    in
        ul [class "main-nav" ] navbar

view : Model -> Html msg
view model =
    div [class "header "]
    [
        div [class "container"]
        [
            div[class "nav-items"]
            [
                a[href "/"] [img [class "site-logo", src "./assets/gopher-orange.png"] [] ],
                renderItems model.itemsNav,
                h1[] [text "Gollery"]
            ]
        ]
    ]