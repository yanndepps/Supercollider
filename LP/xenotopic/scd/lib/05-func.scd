

// function to partially match filename for buffers
~getSmp = { |regexp|
    ~bfrList.detect { |buf|
        regexp.matchRegexp(buf.path)
    }
};
