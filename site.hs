{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Control.Monad (liftM)

import qualified Data.Text as T
import Data.Text (Text)

import           Hakyll

grouper :: (MonadFail m, MonadMetadata m) => [Identifier] -> m [[Identifier]]
grouper ids = (liftM (paginateEvery 10) . sortRecentFirst) ids

makeId :: PageNumber -> Identifier
makeId pageNum = fromFilePath $ "posts/page/" ++ (show pageNum) ++ "/index.html"

main :: IO ()
main = hakyll $ do
    match "raw/**" $ do
        route $ customRoute $ \i -> do
            let stripped = T.stripPrefix "raw/" . T.pack . toFilePath $ i
            case stripped of
                Just p ->
                    T.unpack p
                Nothing ->
                    error "Couldn't strip raw/ prefix from raw/ folder, this should never happen."
        compile copyFileCompiler

    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "images/icons/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/fonts/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "scripts/*" $ do
        route   idRoute
        compile copyFileCompiler

    match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["posts/page/[0-9]*/index.html"] $ do
        pag <- buildPaginateWith grouper "posts/*" makeId
        paginateRules pag $ \pageNum pattern -> do
            route idRoute
            compile $ do
                posts <- recentFirst =<< loadAllSnapshots "posts/*" "content"
                let paginateCtx = paginateContext pag pageNum
                    ctx =
                        constField "title" ("Archive - Page " ++ (show pageNum)) <>
                        listField "posts" postCtx (return posts) <>
                        paginateCtx <>
                        defaultContext
                makeItem ""
                    >>= loadAndApplyTemplate "templates/archive-page.html" ctx
                    >>= loadAndApplyTemplate "templates/default.html" ctx
                    >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- return . take 5 =<< recentFirst =<< loadAllSnapshots "posts/*" "content"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

postCtx :: Context String
postCtx =
    dateField "date" "%Y-%m-%d" `mappend`
    teaserField "teaser" "content" `mappend`
    defaultContext
