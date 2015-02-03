#!/usr/bin/env python

import unittest


class TestGetVolume(unittest.TestCase):

    def test_longer_path_with_spaces(self):
        self.assertEqual(get_volume("/Volumes/audio.data 1/backups/users mbp mountain lion"),
                         '/Volumes/audio.data 1/')

    def test_volume_path_is_not_altered(self):
        self.assertEqual(get_volume("/Volumes/audio.data 1/"),
                         '/Volumes/audio.data 1/')

    def test_path_must_contain_volumes(self):
        with self.assertRaises(SystemExit) as cm:
            get_volume("/foobar/audio.data 1/schmurz")
        self.assertEqual(cm.exception.code, 1)

    def test_path_must_point_to_volumes(self):
        with self.assertRaises(SystemExit) as cm:
            get_volume("/Volumes/")
        self.assertEqual(cm.exception.code, 2)


def get_volume(full_path):
    import sys
    """Extract the path to the volume from the full_path."""
    el = full_path.split('/', 3)
    try:
        el[3] = ''  # make sure closing slash is kept!
    except IndexError:
        sys.exit(2)
    if el[1] != 'Volumes':
        sys.exit(1)
    return '/'.join(el)

if __name__ == '__main__':
    unittest.main()
