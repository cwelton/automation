#!/usr/bin/env python

import sys
import unittest
from subprocess import Popen, PIPE

class TestHello(unittest.TestCase):
    
    def runcmd(self, cmd):
        env = {'PATH': '.'}
        p = Popen(cmd, stdout=PIPE, stderr=PIPE, env=env)
        return p.communicate()[0]
        

    def test_start(self):
        self.assertTrue(self.runcmd('hello').startswith('hello'))

    def test_wordcount(self):
        self.assertEqual(len(self.runcmd('hello').split()), 2)

    def test_end(self):
        self.assertTrue(self.runcmd('hello').endswith('world\n'))

if __name__ == '__main__':
    unittest.main()
