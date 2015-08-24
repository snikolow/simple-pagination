namespace ZephirTools\Pagination;

class Configurator {

    /** @var array */
    protected config = [];

    /**
     * Apply default configuration.
     * If there is user defined configuration passed as an
     * argument, then merge it along with the default one.
     *
     * @param array config
     */
    public function applyConfig(Array config) {
        var currentPage = 1;
        var defaultConfig = [];

        if( isset(_GET["page"]) ) {
            let currentPage = intval(_GET["page"]);
        }

        let defaultConfig = [
            "baseUrl": "",
            "page": currentPage,
            "perPage": 5,
            "displayItems": 2,
            "totalItems": 0,
            "listTagClass": "pagination",
            "fullTagOpen": "<nav>",
            "fullTagClose": "</nav>",
            "pageTagOpen": "<li>",
            "pageTagClose": "</li>",
            "activeItemTagOpen": "<li class=\"active\">",
            "activeItemTagClose": "</li>",
            "firstPageLabel": "First",
            "lastPageLabel": "Last",
            "nextPageLabel": "&gt;",
            "prevPageLabel": "&lt;",
            "useTrailingSlash": true,
            "seoFriendlyStyle": false,
            "extraUrlParams": []
        ];

        let this->config = array_merge(defaultConfig, config);
    }

    /**
     * Format url based on our configuration.
     *
     * @param int pageNum
     * @return string
     */
    public function formatPageUrl(pageNum = null) -> string {
		var trailingSlash, params, baseUrl = "";

		let params = this->getItem("extraUrlParams");

		// Check if trailing slash is required first
		let trailingSlash = this->getItem("useTrailingSlash") ? "/" : "";

		let baseUrl = rtrim(this->getItem("baseUrl"), "/");

		if( pageNum ) {
			if( this->getItem("seoFriendlyStyle") ) {
                let baseUrl = sprintf("%s%s%s", baseUrl, trailingSlash, pageNum);

				if( count(params) > 0 ) {
					let baseUrl .= sprintf("?%s", http_build_query(params));
				}
			}
			else {
                if( count(params) ) {
					let params = array_merge(params, ["page": pageNum]);
				}
				else {
					let params = ["page": pageNum];
				}

				let baseUrl = sprintf(
					"%s?%s"
					, baseUrl
					, http_build_query(params)
				);
			}
		}

		return baseUrl;
	}

    /**
     * Return value from configuration by given index/key.
     *
     * @param string key
     * @return mixed
     * @throws \OutOfBoundsException
     */
    public function getItem(key) {
        if( ! isset(this->config[ key ]) ) {
            throw new \OutOfBoundsException(
                sprintf("Request option %s was not defined in configuration!", key)
            );
        }

        return this->config[ key ];
    }

    /**
     * Get configuration array.
     *
     * @return array
     */
    public function getConfig() -> Array {
        return this->config;
    }

}
