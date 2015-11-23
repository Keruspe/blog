{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.List       (stripPrefix)
import Data.Maybe      (fromMaybe)
import Data.Monoid     ((<>))
import System.FilePath (takeFileName)

import Hakyll

-- Custom configuration

configuration :: Configuration
configuration = defaultConfiguration
    { tmpDirectory  = "/tmp/hakyll"
    , ignoreFile    = ignoreFile'
    , deployCommand = "./scripts/publish.sh"
    }
  where
    ignoreFile' path
        | fileName == ".htaccess" = False
        | otherwise               = ignoreFile defaultConfiguration path
      where
        fileName = takeFileName path

-- Contexts

postCtx :: Context String
postCtx = dateField "date" "%B %e, %Y" <> defaultContext

allPostsCtx :: Context String
allPostsCtx = constField "title" "All posts" <> postCtx

homeCtx :: Context String
homeCtx = constField "title" "Home" <> postCtx

feedCtx :: Context String
feedCtx = bodyField "description" <> postCtx

tagsCtx :: Tags -> Context String
tagsCtx tags = tagsField "prettytags" tags <> postCtx

-- Feed configuration

feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle       = "Keruspe's blag - RSS feed"
    , feedDescription = "Various free software hacking stuff"
    , feedAuthorName  = "Marc-Anroine Perennou"
    , feedAuthorEmail = "Marc-Antoine@Perennou.com"
    , feedRoot        = "http://www.imagination-land.org"
    }

-- Auxiliary compilers

externalizeUrls :: String -> Item String -> Compiler (Item String)
externalizeUrls root item = return $ withUrls ext <$> item
  where
    ext x = if isExternal x then x else root ++ x

unExternalizeUrls :: String -> Item String -> Compiler (Item String)
unExternalizeUrls root item = return $ withUrls unExt <$> item
  where
    unExt x = fromMaybe x $ stripPrefix root x

postList :: Tags -> Pattern -> ([Item String] -> Compiler [Item String]) -> Compiler String
postList tags pattern preprocess' = do
    postItemTpl <- loadBody "templates/postitem.html"
    posts <- preprocess' =<< loadAll pattern
    applyTemplateList postItemTpl (tagsCtx tags) posts

-- Main

main :: IO ()
main = hakyllWith configuration $ do
    -- Build tags
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")

    -- Compress CSS
    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    -- Copy files and images
    match ("files/*" .||. "files/*/*" .||. "files/*/*/*" .||. "images/*" .||. "images/*/*" .||. "images/*/*/*") $ do
        route   idRoute
        compile copyFileCompiler

    -- Copy favicon, htaccess...
    match "data/*" $ do
        route   $ gsubRoute "data/" (const "")
        compile copyFileCompiler

    -- Render posts
    match "posts/*" $ do
        route   $ setExtension ".html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html" (tagsCtx tags)
            >>= (externalizeUrls $ feedRoot feedConfiguration)
            >>= saveSnapshot "content"
            >>= (unExternalizeUrls $ feedRoot feedConfiguration)
            >>= loadAndApplyTemplate "templates/posts-js.html" (tagsCtx tags)
            >>= loadAndApplyTemplate "templates/default.html" (tagsCtx tags)
            >>= relativizeUrls

    -- Render posts list
    create ["posts.html"] $ do
        route idRoute
        compile $ do
            list <- postList tags "posts/*" recentFirst
            makeItem list
            >>= loadAndApplyTemplate "templates/posts.html" allPostsCtx
            >>= loadAndApplyTemplate "templates/default.html" allPostsCtx
            >>= relativizeUrls

    -- Index
    create ["index.html"] $ do
        route idRoute
        compile $ do
            list <- postList tags "posts/*" (fmap (take 10) . recentFirst)
            makeItem list
            >>= loadAndApplyTemplate "templates/index.html" homeCtx
            >>= loadAndApplyTemplate "templates/default.html" homeCtx
            >>= relativizeUrls

    -- Post tags
    tagsRules tags $ \tag pattern -> do
        let title = "Posts tagged '" ++ tag ++ "'"
        route idRoute
        compile $ do
            list <- postList tags pattern recentFirst
            makeItem ""
                >>= loadAndApplyTemplate "templates/posts.html"
                        (constField "title" title `mappend`
                            constField "body" list `mappend`
                            defaultContext)
                >>= loadAndApplyTemplate "templates/default.html"
                        (constField "title" title `mappend`
                            defaultContext)
                >>= relativizeUrls

    -- Render RSS feed
    create ["rss.xml"] $ do
        route idRoute
        compile $ do
            loadAllSnapshots "posts/*" "content"
                >>= recentFirst
                >>= renderRss feedConfiguration feedCtx

    -- Read templates
    match "templates/*" $ compile templateCompiler

