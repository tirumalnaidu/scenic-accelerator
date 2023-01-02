import sys
import numpy as np
from numpy.core.fromnumeric import shape
from numpy.core.numeric import convolve
from numpy.lib.stride_tricks import as_strided
np.set_printoptions(threshold=sys.maxsize)

# Generate Feature map data randomly
def choose_actn_data(case,actn_h,actn_w,actn_c):
    np.random.seed(2023)
    if case==1:
        input_array=np.arange(actn_c*actn_h*actn_w).reshape(actn_c,actn_h,actn_w)
    elif case==2:
        input_array=np.random.rand(actn_c,actn_h,actn_w)
    elif case==3:
        input_array=np.random.randint(1,10,size=(actn_c,actn_h,actn_w),dtype=int)
    elif case==4:
        input_array=np.random.uniform(1,100,size=(actn_c,actn_h,actn_w))

    np.savetxt("../test-data/test_actn_data.txt", input_array.flatten(), fmt="%d")
    return input_array

# Generate Filter data randomly
def choose_filt_data(case,filt_h,filt_w,filt_c,filters):
    np.random.seed(2023)
    if case==1:
        input_array=np.arange(filters*filt_c*filt_h*filt_w).reshape(filters,filt_c,filt_h,filt_w)
    elif case==2:
        input_array=np.random.rand(filters,filt_c,filt_h,filt_w)
    elif case==3:
        input_array=np.random.randint(1,10,size=(filters,filt_c,filt_h,filt_w),dtype=int)
    elif case==4:
        input_array=np.random.uniform(1,100,size=(filters,filt_c,filt_h,filt_w))

    np.savetxt("../test-data/test_filt_data.txt", input_array.flatten(), fmt="%d")
    return input_array 

# Generate Bias data randomly
def choose_bias_data(case,bias_h,bias_w,bias_c,biases):
    np.random.seed(2023)
    if case==1:
        input_array=np.arange(biases*bias_c*bias_h*bias_w).reshape(biases,bias_c,bias_h,bias_w)
    elif case==2:
        input_array=np.random.rand(biases,bias_c,bias_h,bias_w)
    elif case==3:
        input_array=np.random.randint(1,10,size=(biases,bias_c,bias_h,bias_w),dtype=int)
    elif case==4:
        input_array=np.random.uniform(1,100,size=(biases,bias_c,bias_h,bias_w))

    np.savetxt("../test-data/test_bias_data.txt", input_array.flatten(), fmt="%d")
    return input_array 

def choose_depth_filt_data(case,filt_h,filt_w,filters):
    np.random.seed(2020)
    if case==1:
        input_array=np.arange(filters*filt_h*filt_w).reshape(filters,filt_h,filt_w)
    elif case==2:
        input_array=np.random.rand(filters,filt_h,filt_w)
    elif case==3:
        input_array=np.random.randint(1,10,size=(filters,filt_h,filt_w),dtype=int)
    elif case==4:
        input_array=np.random.uniform(1,100,size=(filters,filt_h,filt_w))

    np.savetxt("../test-data/test_depth_filt_data.txt", input_array.flatten(), fmt="%d")
    return input_array 

def choose_depth_bias_data(case,bias_h,bias_w,biases):
    np.random.seed(2023)
    if case==1:
        input_array=np.arange(biases*bias_h*bias_w).reshape(biases,bias_h,bias_w)
    elif case==2:
        input_array=np.random.rand(biases,bias_h,bias_w)
    elif case==3:
        input_array=np.random.randint(1,10,size=(biases,bias_h,bias_w),dtype=int)
    elif case==4:
        input_array=np.random.uniform(1,100,size=(biases,bias_h,bias_w))

    np.savetxt("../test-data/test_depth_bias_data.txt", input_array.flatten(), fmt="%d")
    return input_array 

def conv2D(array_padded,kernel,stride):
    output_x=((array_padded.shape[0]-kernel.shape[0])/stride+1)
    output_y=((array_padded.shape[1]-kernel.shape[1])/stride+1)
    conv_output=np.zeros((int(output_x),int(output_y)))

    for i in range(conv_output.shape[0]): 
        for j in range(conv_output.shape[1]):
            conv_output[i,j] = (array_padded[i*stride:i*stride+kernel.shape[0],j*stride:j*stride+kernel.shape[1]] * kernel).sum()
    return conv_output

##EXTENDING CONVOLUTION FOR 3D MATRIX
def conv3D(array, kernel,stride):
##We can consider 3D convolution to be a consist of several 2D convolutions along the 3rd dimension
##We will stack 2D convolutions along the thrid dimension with proper strides
##For 3 dimensionl kernel(1x1x32) we need to find the 2D convolution of each layer of kernel then sum them up.
## We will find 2d convolutions for 32 layers and sum them
##No to be confused with filter number. Filters denote the number of kernels so each convoluted output will be stacked depending upon the number of filters
## 4 filters denote 4 convoluted output will be stacked. 
## In a tensor like 4x1x1x32 4 is the number of filter while 32 is the 3rd dimension    

    output_z=int((array.shape[0]-kernel.shape[0])/stride +1)
    return np.stack([sum(conv2D(x, k,stride) for x, k in zip(array[i*stride:i*stride+kernel.shape[0],:,:], kernel)) for i in range(output_z)],0)

##FOR MULTICHANNEL KERNELS IN 2D    
def multi_channel_2D(array,kernel,stride):
    ##The code stacks up convoluted output for each filter
    ## Hence the final matrix will be 3D in nature
    return np.stack([conv2D(array, k, stride) for k in kernel],0)

##FOR MULTICHANNEL KERNELS IN 3D
def multi_channel_3D(array, kernel,stride):
    ##The code stacks up convoluted output for each filter
    ##Hence the final tensor will be 4D in nature
    return np.stack([conv3D(array, k, stride) for k in kernel], 0)

def depth_wise_channel(array,kernel,stride):
    return np.stack([conv2D(a,k,stride) for a,k in zip(array,kernel)],0)

def depth_wise_multi_channel(array,kernel,stride):
    # if we need to convolute each channel with multiple filter we will simply add the convolution values of each channel
    # for a filter the final dimension of the output array will be same as for single channel
    return sum([depth_wise_channel(array,k,stride) for k in kernel])

def add_bias(output_result,bias):
    return output_result+bias

def convolution_3D_operation(stride, channels, num_filt):

    actn_data = choose_actn_data(case=3, actn_h=10, actn_w=10, actn_c=2)
    filt_data = choose_filt_data(case=3, filt_h=3, filt_w=3, filt_c=2, filters=2)

    print(actn_data)
    print(filt_data)

    bias_x=(int((actn_data.shape[2]-filt_data.shape[3])/stride+1))
    bias_y=(int((actn_data.shape[1]-filt_data.shape[2])/stride+1))
    bias_z=(int((actn_data.shape[0]-filt_data.shape[1])/stride+1))
    bias_data = choose_bias_data(case=3, bias_h=bias_x, bias_w=bias_y, bias_c=bias_z, biases=num_filt)

    print("Input Activation Dims  : ", actn_data.shape)
    print("Filter Dims            : ", filt_data.shape)
    print("Bias Dims              : ", bias_data.shape)
    print("Stride                 : ", stride)

    convolve=multi_channel_3D(actn_data,filt_data,stride)
    #convolve=add_bias(convolve,bias_data)

    return convolve

def depth_wise_convolution(stride):
    actn_data = choose_actn_data(case=3, actn_h=10, actn_w=10, actn_c=2)
    filt_data = choose_depth_filt_data(case=3, filt_h=3, filt_w=3, filters=2)

    bias_x=(int((actn_data.shape[2]-filt_data.shape[2])/stride+1))
    bias_y=(int((actn_data.shape[1]-filt_data.shape[1])/stride+1))
    bias_data = choose_depth_bias_data(case=3, bias_h=bias_x, bias_w=bias_y, biases=8)

    print("Input Activation Dims  : ", actn_data.shape)
    print("Filter Dims            : ", filt_data.shape)
    print("Bias Dims              : ", bias_data.shape)
    print("Stride                 : ", stride)

    convolve=depth_wise_channel(actn_data,filt_data,stride)
    #convolve=add_bias(convolve,bias_data)

    return convolve

def multi_channel_depth_wise(stride,num_of_filter_for_each_channel):
    actn_data = choose_actn_data(case=3, actn_h=63, actn_w=62, actn_c=32)
    filt_data = choose_filt_data(case=3, filt_h=3, filt_w=3, filt_c=32,filters=num_of_filter_for_each_channel)

    bias_x=(int((actn_data.shape[2]-filt_data.shape[3])/stride+1))
    bias_y=(int((actn_data.shape[1]-filt_data.shape[2])/stride+1))
    bias_data = choose_depth_bias_data(case=3, bias_h=bias_x, bias_w=bias_y, biases=32)

    print("Input Activation Dims  : ", actn_data.shape)
    print("Filter Dims            : ", filt_data.shape)
    print("Filter for each channel:",num_of_filter_for_each_channel)
    print("Bias Dims              : ", bias_data.shape)
    print("Stride                 : ", stride)

    convolve=depth_wise_multi_channel(actn_data,filt_data,stride)
    convolve=add_bias(convolve,bias_data)
    return convolve

def point_wise_convolution(actn_data,stride):
    filt_data=choose_filt_data(case=3, filt_h=1, filt_w=1, filt_c=32, filters=8)
    bias_x=(int((actn_data.shape[2]-filt_data.shape[3])/stride+1))
    bias_y=(int((actn_data.shape[1]-filt_data.shape[2])/stride+1))
    bias_z=(int((actn_data.shape[0]-filt_data.shape[1])/stride+1))
    bias_data = choose_bias_data(case=3, bias_h=bias_x, bias_w=bias_y, bias_c=bias_z, biases=8)

    print("Input Activation Dims  : ", actn_data.shape)
    print("Filter Dims            : ", filt_data.shape)
    print("Stride                 : ", stride)
    print("Bias Dims              : ", bias_data.shape)

    convolve=multi_channel_3D(actn_data,filt_data,stride)
    convolve=add_bias(convolve,bias_data)
    return convolve

def pool2d(array, kernel_size, stride, padding, pool_mode='max'):

    array = np.pad(array, padding, mode='constant')
    output_shape = ((array.shape[0] - kernel_size)//stride + 1,
                    (array.shape[1] - kernel_size)//stride + 1)
    kernel_size = (kernel_size, kernel_size)
    array_w = as_strided(array, shape = output_shape + kernel_size, 
                        strides = (stride*array.strides[0],
                                   stride*array.strides[1]) + array.strides)
    array_w = array_w.reshape(-1, *kernel_size)

    if pool_mode == 'max':
        return array_w.max(axis=(1,2)).reshape(output_shape)
    elif pool_mode == 'min':
        return array_w.min(axis=(1,2)).reshape(output_shape)
    elif pool_mode == 'avg':
        return array_w.mean(axis=(1,2)).reshape(output_shape)


def pool3d(array,kernel_size, stride, padding, pool_mode):

    print(array)

    print("Pool type  : ", pool_mode)
    print("Input Activation Dims  : ", array.shape)
    print("Filter Dims            : ", kernel_size)
    print("Stride                 : ", stride)

    pool_out=np.array([pool2d(channel, kernel_size, stride, padding, pool_mode) for channel in array])
    return pool_out

# ##DRIVER FUNCTION
output_final=convolution_3D_operation(stride=1, channels=2, num_filt=2) ##padding,filters,stride
np.savetxt("../test-data/ref_test_out_data.txt", output_final.flatten(), fmt="%d")
print(output_final)
print("Conv Output Dims       : ", output_final.shape, "\n")

# output_final=depth_wise_convolution(stride=1) ##padding,filters,stride
# print("Conv Output Dims       : ", output_final.shape,"\n")
# np.savetxt("data/ref_test_out_data.txt", output_final.flatten(), fmt="%d")
# print(output_final)

# output_final=point_wise_convolution(output_final,stride=1)
# print("Conv Output Dims       :",output_final.shape,"\n")
# np.savetxt("src/data/ref_test_out_data_2.txt", output_final.flatten(), fmt="%d")
#print(output_final)


#------------------------MAX_POOL_3D---------------------------#
# actn_data = choose_actn_data(case=3, actn_h=30, actn_w=30, actn_c=5)
# pool_out=pool3d(actn_data,kernel_size=3,stride=3,padding=0,pool_mode='max') ##padding,filters,stride

# np.savetxt("data/ref_test_out_data.txt", pool_out.flatten(), fmt="%d")
# print(pool_out)
# print("Pool Output Dims       : ", pool_out.shape, "\n")




# #------------------------AVG_POOL_3D---------------------------#
# actn_data = choose_actn_data(case=3, actn_h=7, actn_w=7, actn_c=3)
# pool_out=pool3d(actn_data,kernel_size=2,stride=2,padding=0,pool_mode='max') ##padding,filters,stride

# print("Pool Output Dims       : ", pool_out.shape, "\n")
# np.savetxt("data/ref_test_out_data.txt", pool_out.flatten(), fmt="%d")
# print(pool_out)