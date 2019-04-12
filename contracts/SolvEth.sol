pragma solidity >=0.4.22 <0.6.0;

library SolvEth {
    
    //babylonian square root
    function sqrt(int x) pure public returns (int y)  {
        int z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
    

    // Crout uses unit diagonals for the upper triangle
    function Crout (uint d, int[] memory S) pure public returns (int[] memory){
       
       int[] memory D = new int[]( d*d );
       
       for(uint k = 0; k < d; ++k){
          
          for(uint i = k; i < d; ++i){
             int sum = 0;
             
             for(uint p = 0;  p < k; ++p)
                sum += D[i*d + p] * D[p*d +k ];
            
             D[i*d + k] = S[i*d + k] - sum; // not dividing by diagonals
          }
          
          for(uint j = k+1; j < d; ++j){
              
             int sum = 0;
             for(uint p = 0; p < k; ++p)
                sum += D[k*d + p] * D[p*d + j];
                
             D[k*d + j] = (S[k*d+j] - sum) / D[k*d + k];
          }
       }
       
       return D;
    }
    
    function solveCrout(uint d, int[] memory LU, int[] memory b) pure public returns (int[] memory){
       
       int[] memory x= new int[]( d );
       int[] memory y= new int[]( d );
       
       for(uint i = 0; i < d; ++i){
           
          int sum = 0;
          for(uint k = 0; k < i; ++k)
                sum += LU[i*d+k] * y[k];
                
          y[i]= (b[i] - sum) / LU[i*d + i];
       }
       
       for(uint i = d-1; i >= 0; --i){
           
          if (i > d) break; //check for "underflow"
          
          int sum = 0;
          
          for(uint k = i+1; k < d; ++k)
                sum += LU[i*d + k] * x[k];
          x[i] = (y[i] - sum); // not dividing by diagonals
       }
       
       return x;
    }
    
    
    
    // Doolittle uses unit diagonals for the lower triangle
    function Doolittle(uint d, int[]  memory S) pure public returns (int[] memory){
       
       int[] memory D = new int[]( d*d );
       
       for(uint k = 0; k < d; ++k){
          for(uint j = k; j < d; ++j){
              
             int sum = 0;
             for(uint p = 0; p < k; ++p)
                sum += D[k*d + p] * D[p*d + j];
                
             D[k*d + j] = (S[k*d + j] - sum); // not dividing by diagonals
          }
          for(uint i = k + 1; i < d; ++i){
              
             int sum = 0;
             for(uint p = 0; p < k; ++p)
                sum += D[i*d + p] * D[p*d + k];
                
             D[i*d + k] = (S[i*d + k ] - sum) / D[k*d + k];
          }
       }
       
       return D;
    }
    
    function solveDoolittle(uint d, int[] memory LU, int[] memory b) pure public returns (int[] memory) {
        
       int[] memory x= new int[]( d );
       int[] memory y= new int[]( d );
    
       for(uint i = 0; i < d; ++i){
           
          int sum = 0;
          for(uint k = 0; k < i; ++k)
            sum += LU[i*d + k] * y[k];
            
          y[i] = (b[i] - sum); // not dividing by diagonals
       }
       
    
       for(uint i = d-1; i >= 0; --i){
          if ( i > 100 ) break;
          
          int sum = 0;
          for( uint k = i+1; k < d; ++k )
            sum += LU[i*d + k] * x[k];
            
          x[i] = (y[i] - sum) / LU[i*d + i];
       }
      
       return x;
    }
    
    
    
    // Cholesky requires the matrix to be symmetric positive-definite
    function Cholesky(uint d, int[] memory S) pure public returns (int[] memory) {
        
       int[] memory D = new int[]( d*d );
       
       for(uint k = 0; k < d; ++k){
          int sum = 0;
          
          for(uint p = 0; p < k; ++p)
            sum += D[k*d + p] * D[k*d + p];
          
          D[k*d+k] = sqrt(S[k*d + k] - sum);
          
          for(uint i = k + 1; i < d; ++i){
             int sum2 = 0;
             
             for(uint p = 0; p < k; ++p)
                sum2 += D[i*d+p] * D[k*d+p];
             D[i*d+k] = (S[i*d+k] - sum2) / D[k*d+k];
          }
       }
       return D;
    }
    

    // This version could be more efficient on some architectures
    // Use solveCholesky for both Cholesky decompositions
    function CholeskyRow(uint d, int[] memory S) pure public returns (int[] memory){
       
       int[] memory D = new int[]( d*d );
       
       for(uint k = 0; k < d; ++k){
          for(uint j = 0; j < d; ++j){
             int sum = 0;
             for(uint p = 0; p < j; ++p)
                sum += D[k*d + p] * D[j*d+p];
             D[k*d+j] = (S[k*d+j] - sum) / D[j*d+j];
          }
          
          int sum = 0;
          for(uint p = 0; p < k; ++p)
                sum += D[k*d + p] * D[k*d + p];
        
          D[k*d+k] = sqrt(S[k*d+k] - sum);
       }
       return D;
    }
    
    
    function solveCholesky(uint d, int[] memory LU, int[] memory b) pure public returns (int[] memory){
       
       int[] memory x= new int[](d);
       int[] memory y= new int[](d);
       
       for(uint i = 0; i < d; ++i){
          int sum = 0;
          
          for(uint k = 0; k < i; ++k)
              sum += LU[i*d+k] * y[k];
              
          y[i] = (b[i]-sum ) / LU[i*d+i];
       }
       
       for(uint i = d - 1; i >= 0; --i){
          int sum = 0;
          
          for(uint k = i + 1; k < d; ++k)
                sum += LU[k*d + i] * x[k];
                
          x[i] = (y[i] - sum) / LU[i*d + i];
       }
       
       return x;
    }

}