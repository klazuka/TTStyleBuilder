#!/usr/bin/env python
# encoding: utf-8
"""
BLIPListenerTest.py

Created by Jens Alfke on 2008-06-04.
This source file is test/example code, and is in the public domain.
"""

from BLIP import Listener

import asyncore
import logging
import unittest


class BLIPListenerTest(unittest.TestCase):
    
    def testListener(self):
        def handleRequest(request):
            logging.info("Got request!: %r",request)
            body = request.body
            assert len(body)<32768
            assert request.contentType == 'application/octet-stream'
            assert int(request['Size']) == len(body)
            assert request['User-Agent'] != None
            for i in xrange(0,len(request.body)):
                assert ord(body[i]) == i%256
            
            response = request.response
            response.body = request.body
            response['Content-Type'] = request.contentType
            response.send()
        
        listener = Listener(46353)
        listener.onRequest = handleRequest
        logging.info("Listener is waiting...")
        
        try:
            asyncore.loop()
        except KeyboardInterrupt:
            logging.info("KeyboardInterrupt")

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    unittest.main()
