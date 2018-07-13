#!/usr/bin/env python3

import os

import treq
from klein              import route, run
from twisted.web.static import File
from csvtsdb            import CsvTsdb

DATAFILE      = os.getenv('DATAFILE', './data.csv')
PORT          = int(os.getenv('PORT', '8500'))
STATIC_DIR    = './webui/public/'
ELM_DEVSERVER = 'http://localhost:8000'  # Proxies this from /dev/

@route('/track/')
def test(request):
    return CsvTsdb(DATAFILE).resource

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

    url = ELM_DEVSERVER.encode('utf-8') + request.uri[len('/dev'):]
    d = treq.request(request.method.decode('ascii'), url)
    d.addCallback(stream_response)
    return d

@route('/', branch=True)
def static_files(request):
    return File(STATIC_DIR)

if __name__ == '__main__':
    run(endpoint_description=r"tcp6:port={}:interface=\:\:".format(PORT))
