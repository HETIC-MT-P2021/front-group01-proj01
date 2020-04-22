module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Pages.Home as Home
import Pages.About as About
import Pages.NotFound as NotFound
import Html exposing (..)
import Html.Attributes exposing (..)
import Url

-- MAIN

type Route = 
  Home 
  | About
  | NotFound

main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }

-- MODEL

type alias Model =
  { 
    flags : ()
  , key : Nav.Key
  , url : Url.Url
  , route : Route
  }

init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { flags = flags, key = key, url = url, route = Home }
    , Cmd.none
    )

-- UPDATE

type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
  | HomeMsg Home.Msg
  | AboutMsg About.Msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      ( { model | url = url }
      , Cmd.none
      )

    HomeMsg _ ->
      (model, Cmd.none)

    AboutMsg _ ->
      (model, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none

-- VIEW

view : Model -> Browser.Document Msg
view model =
  { title = "URL changer"
  , body =
      [ text "The current URL is: "
      , b [] [ text (Url.toString model.url) ]
      , ul []
          [ viewLink "/home"
          , viewLink "/image"
          , viewLink "/imagelist"
          , viewLink "/category"
          , viewLink "/categorylist"
          , viewLink "/about"
          ]
      ]
  }

viewLink : String -> Html msg
viewLink path =
  li [] [ a [ href path ] [ text path ] ]

viewMain : Model -> Html Msg
viewMain model = 
    case model.url.path of
        "/home" ->
            Home.view ({ title = "home"}) |> Html.map HomeMsg
        "/about" ->
            About.view ({ title = "about"}) |> Html.map AboutMsg
        _ ->
            Home.view ({ title = "home"}) |> Html.map HomeMsg
