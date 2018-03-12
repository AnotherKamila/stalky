#!/usr/bin/env python3

import treq
from klein   import route, run
from csvtsdb import CsvTsdb

DATAFILE      = './data.csv'
ELM_DEVSERVER = b'http://localhost:8000'  # Proxies this from /dev/ (and allows CORS)
PORT          = 8501


@route('/track/')
def test(request):
    return CsvTsdb('./data.csv').resource

# for development
@route('/dev/', branch=True)
def proxy_devserver(request):
    def stream_response(response):
        request.setResponseCode(response.code)
        for key, values in response.headers.getAllRawHeaders():
            for value in values:
                request.setHeader(key, value)
        d = treq.collect(response, request.write)
        d.addCallback(lambda _: request.finish())
        return d

    d = treq.request(request.method.decode('ascii'), ELM_DEVSERVER + request.uri[len('/dev'):])
    d.addCallback(stream_response)
    return d


if __name__ == '__main__':
    run("localhost", 8501)
