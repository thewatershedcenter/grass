# %%
from operator import truediv
import subprocess
import os
import argparse
import pathlib
from numpy import zeros
import pandas as pd
import numpy as np

# %%
def parse_arguments():
    '''parses the arguments, returns args'''

    # init parser
    parser = argparse.ArgumentParser()

    # add args
    parser.add_argument(
        '--epsg',
        type=int,
        required=True,
        help='Number code of epsg string.',
    )

    parser.add_argument(
        '--data_dir',
        type=str,
        required=True,
        help='Directory containing DTM and if applicable, AOI vector.',
    )

    parser.add_argument(
        '--dtm',
        type=str,
        required=True,
        help='''Full path to Digital terrain model as geoTiff.
        dtm must be located in data-dir.'''
    )

    parser.add_argument(
        '--aoi',
        type=str,
        required=False,
        help='Optional. Full path to AOI vector. AOI vector must be in data_dir.'
    )

    parser.add_argument(
        '--output_dir',
        type=str,
        required=True,
        help='srs of input.')

    parser.add_argument(
        '--search',
        type=int,
        required=False,
        help='Outer seach radius, in pixels, for geomorphons algorithm.'
    )

    parser.add_argument(
        '--skip',
        type=int,
        required=False,
        help='Internal seach radius, in pixels, for geomorphons algorithm.'
    )

    parser.add_argument(
        '--flat',
        type=str,
        required=False,
        help='Flatness threshold, in degrees, for geomorphons algorithm.'
    )

    parser.add_argument(
        '--neighbor_size',
        type=int,
        required=False,
        help='Size of neighborhood for neigborhood function'
    )

    parser.add_argument(
        '--method',
        type=str,
        required=False,
        help='''Neighborhood operation. One of average, median, mode,
         minimum, maximum, range, stddev, sum, count, variance, diversity,
         interspersion, quart1, quart3, perc90, quantile. Default is sum.''',
        default='sum'
    )

    parser.add_argument(
        '--gauss',
        type=float,
        required=False,
        help='Sigma, in cells, for gaussian filter. If omitted flat filter is used'
    )

    parser.add_argument(
        '--trials',
        type=int,
        required=False,
        help='''Number of trials to run with different values for search, skip, flat,
        neighbor_size and gaussian'''
    )

    # parse the args
    args = parser.parse_args()

    # make path objects from data, dtm
    dtm = pathlib.Path(args.dtm)
    data = pathlib.Path(args.data_dir)

    # change args.dtm and args.aoi to relative path from data
    args.dtm = str(dtm.relative_to(*data.parts))
    if args.aoi:
        aoi = pathlib.Path(args.aoi)
        args.aoi = str(aoi.relative_to(*data.parts))
    else:
        # if None change to empty string
        args.aoi = ''

    # avoid Nonetype in output for gauss
    if not args.gauss:
        args.gauss = ''

    return args


def get_trial_params(n_trials):
    '''returns df of parameters for geomorph container'''
    params = pd.DataFrame(
        columns=[
            'search',
            'skip',
            'flat',
            'neighbor_size',
            'gauss'
            ]
        )

    search = np.random.randint(30, size=n_trials)

    if search.min() > 1:
        skip = np.random.randint(search.min(), size=n_trials)
    else:
        skip = np.zeros_like(search)

    flat = np.random.randint(17, size=n_trials)

    neighbor_size = np.random.random(size=n_trials) * 9

    gauss = (np.random.randint(2, size=n_trials) *
                np.random.random(seiz=n_trials) * 0.75 *
                neighbor_size)


    params['search'] = search
    params['skip'] = skip
    params['flat'] = flat
    params['neighbor_size'] = neighbor_size
    params['gauss'] = gauss

    return params


def build_command(args):
    '''
    builds docker run cammands based on args.
    returns list of commands for subprocess'''

    cmd = f'docker run -it --rm --pull=always --user=$(id -u):$(id -g) --volume $PWD:/work --volume {args.data_dir}:/data --volume {args.output_dir}:/out --env HOME=/work quay.io/wrtc/geomorphon:py-latest EPSG="epsg:{args.epsg}" DTM="{args.dtm}" SRCH="{args.search}" SKP="{args.skip}" FLT="{args.flat}" SZ="{args.neighbor_size}"'

    if args.aoi:
        cmd = cmd + f' AOI={args.aoi}'
    if args.gauss:
        cmd = cmd + f' GAUSS={args.gauss}'

    return cmd

# %%
if __name__ == '__main__':

    # get the args
    args = parse_arguments()

    # if --trials arg given, get trial params
    if args.trials:
        params = get_trial_params(args.trials)
        params['epsg'] = args.epsg
        params['dtm'] = args.dtm
        params['aoi'] = args.aoi
        params['output_dir'] = args.output_dir
        params['data_dir'] = args.data_dir
    else:
        params = pd.DataFrame(
        columns=[
            'search',
            'skip',
            'flat',
            'neighbor_size',
            'gauss'
            ]
        )

        params['search'] = [args.search]
        params['skip'] = [args.skip]
        params['flat'] = [args.flat]
        params['neighbor_size'] = [args.neighbor_size]
        params['gauss'] = [args.gauss]
        params['epsg'] = [args.epsg]
        params['dtm'] = [args.dtm]
        params['aoi'] = [args.aoi]
        params['output_dir'] = [args.output_dir]
        params['data_dir'] = [args.data_dir]


    for _, row in params.iterrows():
        cmd = build_command(row)

        print()
        print(cmd)
        print()

        _ = subprocess.run(cmd, shell=True)


# %%
# python slope_geomorph.py --epsg='26910' --data_dir='/media/data' --dtm='/media/data/arroyo_seco/usgs_1m_DEM/arroyo_seco.vrt' --output_dir='/media/data/arroyo_seco/derivatives'  --search=25 --skip=7 --flat=15 --neighbor_size=7 --aoi=/media/data/arroyo_seco/aoi/aoi.shp