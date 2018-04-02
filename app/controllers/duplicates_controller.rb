class DuplicatesController < ApplicationController
    def unresolved
        @nav_status = 'duplicate'
        @unresolved = true
    end

    def deleted
        @nav_status = 'duplicate'
        @deleted = true
    end

    def merged
        @merged = true
    end
end