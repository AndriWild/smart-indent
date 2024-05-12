-- Test Suite (requires Plenary plugin)
-- run with: PlenaryBustedFile %

describe("some basics", function()

  local align = require("init")._align

  --before_each(function()
  --end)

  it("test nothing to align", function()
    local lines = { "local a = 1" }
    assert.are.same(align("=", 1, lines), lines)
  end)

  it("test align by equal sign", function()

    local lines = {
      "local a = 1",
      "local ab = 1",
      "local abc = 1",
    }

    local expected = {
      "local a   = 1",
      "local ab  = 1",
      "local abc = 1",
    }
    assert.are.same(align("=", 1, lines), expected)
  end)

  it("test align by comma for function parameters", function()

    local lines = {
      'fn("helo", 1)',
      'fn("This is a long text", 2)',
      'fn("Debug mode on", 3)',
    }

    local expected = {
      'fn("helo",                1)',
      'fn("This is a long text", 2)',
      'fn("Debug mode on",       3)',
    }
    assert.are.same(align(",", 1, lines, false), expected)
  end)

end)
