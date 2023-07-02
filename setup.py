# This code is taken from Krish Naik Tutorial

from setuptools import find_packages, setup
from typing import List

HYPHEN_E_DOT='-e .'

def get_requirements(file_path:str) ->List[str]:
  '''
  Returns list of requirements
  '''

  requirements=[]
  with open(file_path) as file_obj:
     requirements=file_obj.readlines()
     requirements=[req.replace("\n","")  for req in requirements]

     if HYPHEN_E_DOT in requirements:
        print(requirements)
        requirements.remove("-e .")

  return requirements

setup(
  name='MD1',
  version='0.0.1',
  author='Priyesh Patel',
  author_email='priyesh3386@yahoo.co.uk',
  packages=find_packages(),
  install_requires = get_requirements('requirements.txt') )

