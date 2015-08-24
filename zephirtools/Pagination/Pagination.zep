namespace ZephirTools\Pagination;

class Pagination {

    /** @var Configurator */
    private configurator;

    /**
     * Class constructor
     *
     * @param  array config
     * @return void
     */
    public function __construct(Array! config = []) {
        let this->configurator = new Configurator();

        this->configurator->applyConfig(config);
    }

    /**
     * Set custom configuration.
     *
     * @param array config
     * @return Pagination
     */
    public function setConfig(Array! config) {
        this->configurator->applyConfig(config);

        return this;
    }

    /**
     * Get Configurator instance
     *
     * @return Configurator
     */
    public function getConfigurator() -> <Configurator> {
        return this->configurator;
    }

    /**
     * Return offset based on current page and displayed items per page.
     *
     * @return int
     */
    public function getOffset() -> int {
        return (this->configurator->getItem("perPage") * (this->configurator->getItem("page") - 1));
    }

    /**
     * Get limit. Normally this should be the amount of displayed items.
     * This one along with @getOffset() should be used when querying for results.
     *
     * @return int
     */
    public function getLimit() -> int {
        return this->configurator->getItem("perPage");
    }

    public function getHtmlOutput() {
        var totalItems, perPage, pagesCount, l, index, currentPage = 1, output = "";

        let totalItems = this->configurator->getItem("totalItems");
        let perPage = this->configurator->getItem("perPage");

        // If our query returned no items, or by any chance displayed items per page are 0,
        // then we simply return an empty string.
        if( totalItems === 0 || perPage === 0 ) {
            return "";
        }

        let pagesCount = ceil(totalItems / perPage);
        let currentPage = this->configurator->getItem("page");

        // If we have only a single page of results to display,
        // then there is no need to generate any html whatsoever.
        if( pagesCount === 1 || currentPage > pagesCount ) {
            return "";
        }

        // Start generating our HTML with the opening tag defined in our configuration
        let output = this->configurator->getItem("fullTagOpen") . "\n";

        // Start pagination unordered list
		let output .= "<ul class=\"" . this->configurator->getItem("listTagClass") . "\">\n";

        // First page. Should we output?
		if( currentPage > (this->configurator->getItem("displayItems") + 1) ) {
			let output .= sprintf(
				"%s<a href=\"%s\">%s</a>%s\n"
				, this->configurator->getItem("pageTagOpen")
				, this->configurator->formatPageUrl()
				, this->configurator->getItem("firstPageLabel")
				, this->configurator->getItem("pageTagClose")
			);
		}

        // Previous page. Should we output this?
		if( currentPage > 1 ) {
			let output .= sprintf(
				"%s<a href=\"%s\">%s</a>%s\n"
				, this->configurator->getItem("pageTagOpen")
				, this->configurator->formatPageUrl( currentPage - 1 )
				, this->configurator->getItem("prevPageLabel")
				, this->configurator->getItem("pageTagClose")
			);
		}

        // List the rest of the pages. Let the show begin!
		for l in range((this->getStart() - 1), this->getEnd(pagesCount)) {
			let index = (l * perPage) - perPage;

			if( index >= 0 ) {
				if( l == currentPage ) {
					let output .= sprintf(
						"%s<a href=\"#\">%s</a>%s\n"
						, this->configurator->getItem("activeItemTagOpen")
						, currentPage
						, this->configurator->getItem("activeItemTagClose")
					);
				}
				else {
					let output .= sprintf(
						"%s<a href=\"%s\">%s</a>%s\n"
						, this->configurator->getItem("pageTagOpen")
						, this->configurator->formatPageUrl(l)
						, l
						, this->configurator->getItem("pageTagClose")
					);
				}
			}
		}

        // Next page. Should we output?
		if( (currentPage + 1) <= pagesCount ) {
			let output .= sprintf(
                "%s<a href=\"%s\">%s</a>%s\n"
                , this->configurator->getItem("pageTagOpen")
				, this->configurator->formatPageUrl( currentPage + 1 )
				, this->configurator->getItem("nextPageLabel")
				, this->configurator->getItem("pageTagClose")
			);
		}

		// Last page. We cannot forget about this page, right?
		if( currentPage < (pagesCount - 2) ) {
			let output .= sprintf(
				"%s<a href=\"%s\">%s</a>%s\n"
				, this->configurator->getItem("pageTagOpen")
				, this->configurator->formatPageUrl( pagesCount )
				, this->configurator->getItem("lastPageLabel")
				, this->configurator->getItem("pageTagClose")
			);
		}

        // End pagination unordered list
		let output .= "</ul>\n";

        // Finish our output by adding the closing tag.
        let output .= this->configurator->getItem("fullTagClose") . "\n";

        return output;
    }

    /**
     * Get the start index.
     *
     * @return int
     */
    private function getStart() -> int {
        var page, displayItems;

        let page = this->getConfigurator()->getItem("page");
        let displayItems = this->getConfigurator()->getItem("displayItems");

        return ((page - displayItems) > 0) ? (page - (displayItems - 1)) : 1;
    }

    /**
     * Get the end index based on total amount of pages.
     * This method along with @getStart() are used when
     * rendering pagination items, so that we can know
     * exactly how many page numbers to display.
     *
     * @param int totalPages
     * @return int
     */
    private function getEnd(int totalPages) -> int {
        var page, displayItems;

        let page = this->getConfigurator()->getItem("page");
        let displayItems = this->getConfigurator()->getItem("displayItems");

        return ((page + displayItems) < totalPages) ? (page + displayItems) : totalPages;
    }

}
