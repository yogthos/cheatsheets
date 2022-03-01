enable unsigned app

    sudo xattr -r -d com.apple.quarantine $GRAALVM_HOME

clean up homebrew cache

    brew update && brew upgrade && brew cleanup
