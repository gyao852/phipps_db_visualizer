class DuplicatesController < ApplicationController
    def unresolved
        @unresolved = true
    end

    def deleted
        @deleted = true
    end

    def merged
        @merged = true
    end
end