"use client";

import {
  DetailedHTMLProps,
  ButtonHTMLAttributes,
  MouseEventHandler,
} from "react";

interface ButtonProps {
  value: string;
  handleClick: MouseEventHandler<HTMLButtonElement> | undefined;
}

type OtherProps = DetailedHTMLProps<
  ButtonHTMLAttributes<HTMLButtonElement>,
  HTMLButtonElement
>;

const Button: React.FC<ButtonProps & OtherProps> = ({
  value,
  handleClick,
  ...props
}) => {
  return (
    <>
      <button onClick={handleClick} {...props}>
        {value}
      </button>
    </>
  );
};

export default Button;
