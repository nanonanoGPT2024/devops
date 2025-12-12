const http = require('http');
const server = http.createServer((req, res) => {
   res.end("Hello From Docker web langsung berubah ga ya?");
});
server.listen(3000, ()=> console.log("running on 3000"));
