module Pages.Home exposing (view, Msg, update, init, Model)

import Html exposing (Html, Attribute, h1, map, text, div, ul, p, button)
import Html.Attributes exposing (class, href)
import Html.Events exposing (..)

import Header
import Footer
import Listing.Categories as Categories

type alias Model =
    { 
        header: Header.Model,
        footer: Footer.Model,
        categories: Categories.Model
    }

init : ( Model, Cmd Msg )
init =
    ( { header = Header.init
      , footer = Footer.init
      , categories = Categories.init
      }, Cmd.none )


type Msg 
    = HeaderMsg Header.Msg
    | FooterMsg Footer.Msg
    | CategoriesMsg Categories.Msg
    | UpdateCategories 

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
    HeaderMsg headerMsg ->
        ( { model | header = Header.update headerMsg model.header }, Cmd.none )

    FooterMsg footerMsg ->
        ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )
    
    CategoriesMsg categoriesMsg ->
        ( { model | categories = Categories.update categoriesMsg model.categories }, Cmd.none )

    -- TODO : Update the Categories Model with new Data
    UpdateCategories ->
        ( Categories.update [{id = 1, name = "toto", description = "toto", createdAt = "", updatedAt = ""}] )


view : Model -> Html Msg
view model =
    div[class "content"]
        [
            map HeaderMsg (Header.view model.header)
            , div []
                [ 
                    h1 [] [ text "Page home" ] 
                ]
            , map CategoriesMsg (Categories.view model.categories)
            , button [ onClick UpdateCategories ] [ text "Categories suivantes" ]
            , map FooterMsg (Footer.view model.footer)
        ]