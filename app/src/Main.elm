module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url exposing (Url, toString)

import Pages.Home as Home
import Pages.Categories as Categories
import Pages.Category as Category
import Pages.Images as Images
import Pages.Image as Image
import Pages.About as About


import Route exposing (Route)

-- MODEL

type Page = 
    HomePage Home.Model
    | CategoriesPage Categories.Model
    | CategoryPage Int Category.Model
    | ImagesPage Images.Model
    | ImagePage Int Image.Model
    | AboutPage About.Model
    | NotFoundPage

type alias Model =
    { 
    key : Nav.Key
    , page : Page
    , route : Route
    }

type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | HomePageMsg Home.Msg
    | CategoriesPageMsg Categories.Msg
    | CategoryPageMsg Category.Msg
    | ImagesPageMsg Images.Msg
    | ImagePageMsg Image.Msg
    | AboutPageMsg About.Msg

-- MAIN
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

init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let 
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , key = key
            }
    in
        initCurrentPage ( model, Cmd.none )

-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
    (LinkClicked urlRequest, _) ->
        case urlRequest of
        Browser.Internal url ->
            ( model, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
            ( model, Nav.load href )

    (UrlChanged url, _)  ->
        let
            newRoute = Route.parseUrl url
        in
            ( { model | route = newRoute }, Cmd.none )
                |> initCurrentPage

    ( HomePageMsg subMsg, HomePage pageModel ) ->
        let
            ( updatedPageModel, updatedCmd ) =
                Home.update subMsg pageModel
        in
            ( { model | page = HomePage updatedPageModel }
            , Cmd.none
            )

    ( CategoriesPageMsg subMsg, CategoriesPage pageModel ) ->
        let
            ( updatedPageModel, updatedCmd ) =
                Categories.update subMsg pageModel
        in
            ( { model | page = CategoriesPage updatedPageModel }
            , Cmd.none
            )

    ( CategoryPageMsg subMsg, CategoryPage id pageModel ) ->
        let
            ( updatedPageModel, updatedCmd ) =
                Category.update subMsg pageModel
        in
            ( { model | page = CategoryPage id updatedPageModel }
            , Cmd.none
            )

    ( ImagesPageMsg subMsg, ImagesPage pageModel ) ->
        let
            ( updatedPageModel, updatedCmd ) =
                Images.update subMsg pageModel
        in
            ( { model | page = ImagesPage updatedPageModel }
            , Cmd.none
            )

    ( ImagePageMsg subMsg, ImagePage id pageModel ) ->
        let
            ( updatedPageModel, updatedCmd ) =
                Image.update subMsg pageModel
        in
            ( { model | page = ImagePage id updatedPageModel }
            , Cmd.none
            )

    ( AboutPageMsg subMsg, AboutPage pageModel ) ->
        let
            ( updatedPageModel, updatedCmd ) =
                About.update subMsg pageModel
        in
            ( { model | page = AboutPage updatedPageModel }
            , Cmd.none
            )
    
    ( _, _ ) ->
        ( model, Cmd.none )

initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
      ( currentPage, mappedPageCmds ) =
        case model.route of
            Route.NotFound ->
                ( NotFoundPage, Cmd.none )

            Route.Home ->
                let
                    ( pageModel, pageCmds ) = Home.init
                in
                    ( HomePage pageModel, Cmd.none )
            
            Route.Categories ->
                let
                    ( pageModel, pageCmds ) = Categories.init
                in
                    ( CategoriesPage pageModel, Cmd.none )

            Route.Category id ->
                let
                    ( pageModel, pageCmds ) = Category.init id
                in
                    ( CategoryPage id pageModel, Cmd.none )
            
            Route.Images ->
                let
                    ( pageModel, pageCmds ) = Images.init
                in
                    ( ImagesPage pageModel, Cmd.none )

            Route.Image id ->
                let
                    ( pageModel, pageCmds ) = Image.init id
                in
                    ( ImagePage id pageModel, Cmd.none )
        
            Route.About ->
                let
                    ( pageModel, pageCmds ) = About.init
                in
                    ( AboutPage pageModel, Cmd.none )
    in
        ( { model | page = currentPage }
        , Cmd.batch [ existingCmds, mappedPageCmds ]
        )


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

-- VIEW

view : Model -> Browser.Document Msg
view model =
    { title = "Gollery app"
    , body = [ currentView model ]
    }

currentView : Model -> Html Msg
currentView model =
    case model.page of
    NotFoundPage ->
      notFoundView

    HomePage pageModel ->
      Home.view pageModel
        |> Html.map HomePageMsg

    CategoriesPage pageModel ->
      Categories.view pageModel
        |> Html.map CategoriesPageMsg

    CategoryPage _ pageModel ->
      Category.view pageModel
        |> Html.map CategoryPageMsg

    ImagesPage pageModel ->
      Images.view pageModel
        |> Html.map ImagesPageMsg
    
    ImagePage _ pageModel ->
      Image.view pageModel
        |> Html.map ImagePageMsg

    AboutPage pageModel ->
      About.view pageModel
        |> Html.map AboutPageMsg

notFoundView : Html msg
notFoundView =
    div[] 
    [
      h3 [] [ text "404 page introuvable" ],
      a [href "/"] [text "retour a l'accueil"]
    ]