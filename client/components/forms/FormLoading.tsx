import React from "react";
import FormCard from "./FormCard";

const FormLoading: React.FC = () => {
  return (
    <>
      <FormCard label="">
        <div className="flex h-56 w-56 items-center justify-center text-center">
          <svg
            className="animate-spin"
            width="100px"
            height="100px"
            viewBox="0 0 100 100"
            preserveAspectRatio="xMidYMid"
          >
            <path
              d="M10 50A40 40 0 0 0 90 50A40 42 0 0 1 10 50"
              fill="#e15b64"
              stroke="none"
              transform="matrix(1,0,0,1,0,0)"
            ></path>
          </svg>
        </div>
      </FormCard>
    </>
  );
};

export default FormLoading;
