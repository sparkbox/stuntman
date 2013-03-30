
describe("server testing", function() {
  it("should have no users", function() {
    app = require("src/app.js")

    expect(app).not.toBe(null);
  });
});
   