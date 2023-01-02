from PIL import Image
import numpy as np
import cv2

def matrix(x_dim,y_dim):
    transform_mat=np.zeros([x_dim,y_dim],dtype=float)
    j=0;
    for i in range(0,int((x_dim)/2)):
        if(j==y_dim-2):
            transform_mat[i,0]=0.224143868
            transform_mat[i,1]=-0.129409522
            transform_mat[i,y_dim-2]=0.482962913
            transform_mat[i,y_dim-1]=0.836516303
            break
        transform_mat[i,j]=0.482962913
        transform_mat[i,j+1]=0.836516303
        transform_mat[i,j+2]=0.224143868
        transform_mat[i,j+3]=-0.129409522
        j=j+2
    
    j=0;
    for i in range(int((x_dim)/2),x_dim):
        if(j==y_dim-2):
            transform_mat[i,0]=0.836516303
            transform_mat[i,1]=-0.482962913
            transform_mat[i,y_dim-2]=-0.129409522
            transform_mat[i,y_dim-1]=-0.224143868
            break
        transform_mat[i,j]=-0.129409522
        transform_mat[i,j+1]=-0.224143868
        transform_mat[i,j+2]=0.836516303
        transform_mat[i,j+3]=-0.482962913
        j=j+2
    return transform_mat

def image_matrix(img,x_dim=240,y_dim=240):
    dim=(x_dim,y_dim)
    resized = cv2.resize(img, dim, interpolation = cv2.INTER_AREA) 
    return resized;   

result=matrix(240,240)
np.savetxt("DWT_3/transform_matrix_data.txt",result.flatten(),fmt="%.12f")

img = cv2.imread('DWT_3/BraTS20_Training_002_flair.png',cv2.IMREAD_UNCHANGED)
img=image_matrix(img,240,240)
result2 = np.array(img)
print(result2.shape)
np.savetxt("DWT_3/data_matrix_data.txt",result2.flatten(),fmt="%.12f")

##If we want to see the output image
#dwt_load = np.loadtxt("DWT_3/dwt_out_matrix_data.txt",delimiter="\n")
#dwt_load = np.reshape(dwt_load,(240,240,4))
#im = Image.fromarray(np.uint8(dwt_load), 'RGBA')
#im.save("DWT_3/DWT_IMG.png")
#im.show()