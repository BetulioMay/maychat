import type { FieldProps } from "formik";
import React from "react";

interface OtherProps {
  label: string;
}

type CheckboxInputProps = React.DetailedHTMLProps<
  React.InputHTMLAttributes<HTMLInputElement>,
  HTMLInputElement
>;

const Checkbox: React.FC<FieldProps & CheckboxInputProps & OtherProps> = ({
  label,
  field,
  ...props
}) => {
  return (
    <>
      <label
        htmlFor={props.name}
        className={`relative flex h-8 w-16 items-center rounded-full transition-colors
          duration-500
				${field.checked ? "bg-green-500" : "bg-gray-400"}`}
      >
        <input type="checkbox" className="peer sr-only" {...field} {...props} />
        <span className="relative left-1 h-3/4 w-6 rounded-full bg-white transition-all duration-500 peer-checked:left-9"></span>
      </label>
      {label}
    </>
  );
};

export default Checkbox;
